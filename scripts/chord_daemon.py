#!/usr/bin/env python3
"""Chord daemon — hold PrtSc, type sequence, release to emit.

While PrtSc (KEY_SYSRQ) is held, keypresses are captured (not forwarded
to userspace) as a sequence of characters. On PrtSc release, the sequence
is looked up in chord_mappings.MAPPINGS and, if present, typed out on a
virtual keyboard. Empty releases and unknown sequences are no-ops.

Coexists with kanata: reads from kanata's virtual output device (default
name substring: "kanata"), grabs it exclusively, and re-emits the event
stream on a new virtual device consumed by the display server.

Usage:
    python3 chord_daemon.py                  # grab kanata's virt device
    python3 chord_daemon.py --device /dev/input/eventN
    python3 chord_daemon.py --list           # list candidate devices
    python3 chord_daemon.py --dry-run -v     # observe only, no grab

Reload mappings without restart:
    pkill -HUP -f chord_daemon.py
"""

from __future__ import annotations

import argparse
import importlib
import signal
import sys
import time
from pathlib import Path
from typing import Optional

from evdev import InputDevice, UInput, ecodes, list_devices

SCRIPT_DIR = Path(__file__).resolve().parent
sys.path.insert(0, str(SCRIPT_DIR))
import chord_mappings  # type: ignore[import-not-found]  # noqa: E402

LEADER = ecodes.KEY_SYSRQ
MAX_SEQ_LEN = 32


def _build_keymaps() -> tuple[dict[int, str], dict[str, tuple[int, bool]]]:
    """keycode -> char (for reading), char -> (keycode, shift) (for typing)."""
    kc_to_char: dict[int, str] = {}
    char_to_kc: dict[str, tuple[int, bool]] = {}
    for c in "abcdefghijklmnopqrstuvwxyz":
        kc = getattr(ecodes, f"KEY_{c.upper()}")
        kc_to_char[kc] = c
        char_to_kc[c] = (kc, False)
        char_to_kc[c.upper()] = (kc, True)
    for d in "0123456789":
        kc = getattr(ecodes, f"KEY_{d}")
        kc_to_char[kc] = d
        char_to_kc[d] = (kc, False)
    char_to_kc.update({
        " ": (ecodes.KEY_SPACE, False),
        "\n": (ecodes.KEY_ENTER, False),
        "\t": (ecodes.KEY_TAB, False),
        "-": (ecodes.KEY_MINUS, False), "_": (ecodes.KEY_MINUS, True),
        "=": (ecodes.KEY_EQUAL, False), "+": (ecodes.KEY_EQUAL, True),
        "[": (ecodes.KEY_LEFTBRACE, False), "{": (ecodes.KEY_LEFTBRACE, True),
        "]": (ecodes.KEY_RIGHTBRACE, False), "}": (ecodes.KEY_RIGHTBRACE, True),
        ";": (ecodes.KEY_SEMICOLON, False), ":": (ecodes.KEY_SEMICOLON, True),
        "'": (ecodes.KEY_APOSTROPHE, False), '"': (ecodes.KEY_APOSTROPHE, True),
        ",": (ecodes.KEY_COMMA, False), "<": (ecodes.KEY_COMMA, True),
        ".": (ecodes.KEY_DOT, False), ">": (ecodes.KEY_DOT, True),
        "/": (ecodes.KEY_SLASH, False), "?": (ecodes.KEY_SLASH, True),
        "\\": (ecodes.KEY_BACKSLASH, False), "|": (ecodes.KEY_BACKSLASH, True),
        "!": (ecodes.KEY_1, True), "@": (ecodes.KEY_2, True),
        "#": (ecodes.KEY_3, True), "$": (ecodes.KEY_4, True),
        "%": (ecodes.KEY_5, True), "^": (ecodes.KEY_6, True),
        "&": (ecodes.KEY_7, True), "*": (ecodes.KEY_8, True),
        "(": (ecodes.KEY_9, True), ")": (ecodes.KEY_0, True),
        "`": (ecodes.KEY_GRAVE, False), "~": (ecodes.KEY_GRAVE, True),
    })
    return kc_to_char, char_to_kc


KC_TO_CHAR, CHAR_TO_KC = _build_keymaps()


def iter_devices():
    for path in list_devices():
        try:
            yield InputDevice(path)
        except (FileNotFoundError, PermissionError, OSError):
            continue


def find_device(hint: str) -> Optional[InputDevice]:
    if hint.startswith("/"):
        try:
            return InputDevice(hint)
        except (FileNotFoundError, PermissionError):
            return None
    for dev in iter_devices():
        name = dev.name.lower()
        # Skip our own virtual output — otherwise we grab our own feedback.
        if "chord-daemon" in name:
            continue
        if hint.lower() in name:
            return dev
    return None


def wait_for_device(hint: str, timeout: float = 60.0) -> InputDevice:
    deadline = time.monotonic() + timeout
    warned = False
    while time.monotonic() < deadline:
        dev = find_device(hint)
        if dev is not None:
            return dev
        if not warned:
            print(f"chord-daemon: waiting for device matching {hint!r}...", flush=True)
            warned = True
        time.sleep(1.0)
    raise SystemExit(f"chord-daemon: no device matching {hint!r} within {timeout}s")


def type_string(ui: UInput, s: str) -> None:
    for ch in s:
        info = CHAR_TO_KC.get(ch)
        if info is None:
            continue
        code, shift = info
        if shift:
            ui.write(ecodes.EV_KEY, ecodes.KEY_LEFTSHIFT, 1)
        ui.write(ecodes.EV_KEY, code, 1)
        ui.write(ecodes.EV_KEY, code, 0)
        if shift:
            ui.write(ecodes.EV_KEY, ecodes.KEY_LEFTSHIFT, 0)
        ui.syn()


def reload_mappings() -> dict[str, str]:
    importlib.reload(chord_mappings)
    return chord_mappings.MAPPINGS


def list_candidates() -> None:
    print(f"{'path':<20} name")
    print("-" * 60)
    for dev in iter_devices():
        print(f"{dev.path:<20} {dev.name}")


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--device", default="kanata",
                    help="input device path or name substring (default: kanata)")
    ap.add_argument("--list", action="store_true",
                    help="list input devices and exit")
    ap.add_argument("--dry-run", action="store_true",
                    help="observe events without grabbing or emitting")
    ap.add_argument("--verbose", "-v", action="store_true")
    args = ap.parse_args()

    if args.list:
        list_candidates()
        return

    dev = wait_for_device(args.device)

    mappings = chord_mappings.MAPPINGS
    print(f"chord-daemon: source device {dev.path} ({dev.name})", flush=True)
    print(f"chord-daemon: {len(mappings)} mappings loaded", flush=True)

    if args.dry_run:
        ui = None
    else:
        # Explicit vendor/product so libinput sees this as a distinct device
        # rather than a duplicate of the source (kanata's virt).
        ui = UInput.from_device(
            dev,
            name="chord-daemon-virt",
            vendor=0xC0DE,
            product=0xBEEF,
        )
        virt_path = ui.device.path if ui.device else "unknown"
        print(f"chord-daemon: virtual device at {virt_path}", flush=True)
        # Let libinput/X11 enroll the new virtual keyboard before we grab
        # the old one. Without this delay there is a window where no live
        # keyboard is visible to userspace and input freezes.
        time.sleep(0.5)
        dev.grab()
        print("chord-daemon: grabbed source device", flush=True)

    def handle_sighup(_signum, _frame):
        nonlocal mappings
        try:
            mappings = reload_mappings()
            print(f"chord-daemon: reloaded, {len(mappings)} mappings", flush=True)
        except Exception as e:
            print(f"chord-daemon: reload failed: {e}", flush=True)

    signal.signal(signal.SIGHUP, handle_sighup)

    # Sequence semantics: a sequence spans overlapping keypresses. Each new
    # keydown appends its char; the sequence fires on the keyup that drains
    # the set of currently-held sequence keys back to empty. Multiple
    # sequences can be entered per PrtSc-hold; PrtSc release cancels any
    # in-flight (still-held) sequence.
    capturing = False
    sequence: list[str] = []
    held: set[int] = set()
    first_forward_logged = False

    try:
        for event in dev.read_loop():
            # Leader (PrtSc): flip capture state, always swallow the event.
            if event.type == ecodes.EV_KEY and event.code == LEADER:
                if event.value == 1 and not capturing:
                    capturing = True
                    sequence = []
                    held.clear()
                    if args.verbose:
                        print("chord-daemon: capture start", flush=True)
                elif event.value == 0 and capturing:
                    if held and args.verbose:
                        print(f"chord-daemon: cancelled mid-sequence "
                              f"(still held: {sorted(held)})", flush=True)
                    capturing = False
                    sequence = []
                    held.clear()
                continue

            # While capturing: track KEY events; swallow ALL events (including
            # the MSC/SYN partners) so downstream never sees partial groups.
            if capturing:
                if event.type == ecodes.EV_KEY:
                    code, state = event.code, event.value
                    if state == 1:
                        ch = KC_TO_CHAR.get(code)
                        if ch is not None and code not in held and len(sequence) < MAX_SEQ_LEN:
                            sequence.append(ch)
                            held.add(code)
                    elif state == 0 and code in held:
                        held.discard(code)
                        if not held and sequence:
                            key = "".join(sequence)
                            output = mappings.get(key)
                            if args.verbose:
                                print(f"chord-daemon: seq={key!r} -> {output!r}", flush=True)
                            if output is not None and ui is not None:
                                type_string(ui, output)
                            sequence = []
                continue

            # Not capturing: forward the event verbatim. Do NOT add our own
            # SYN — kanata's stream already contains SYN_REPORT events that
            # terminate each event group. An extra SYN splits MSC/KEY pairs
            # into separate groups, which libinput treats as a phantom event.
            if ui is not None:
                ui.write_event(event)
                if args.verbose and not first_forward_logged and event.type == ecodes.EV_KEY:
                    print(f"chord-daemon: forwarding key events "
                          f"(first: code={event.code}, val={event.value})", flush=True)
                    first_forward_logged = True
    except KeyboardInterrupt:
        pass
    finally:
        if ui is not None:
            try:
                dev.ungrab()
            except Exception:
                pass
            ui.close()


if __name__ == "__main__":
    main()
