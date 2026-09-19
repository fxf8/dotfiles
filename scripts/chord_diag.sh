#!/usr/bin/env bash
# Capture diagnostic info while chord_daemon.py is running.
# Runs the daemon for ~3s, snapshots device state, kills it, dumps to a file.
# Keyboard is only frozen during the ~3s window; afterwards it recovers.
#
# Usage:
#   bash chord_diag.sh
#   cat /tmp/chord-diag.txt   # (after the script exits)

set -u
OUT=/tmp/chord-diag.txt
DAEMON_OUT=/tmp/chord-daemon-out.txt
DAEMON_PY="$HOME/Projects/dotfiles/scripts/chord_daemon.py"

{
    echo "=================================================="
    echo " BEFORE daemon starts"
    echo "=================================================="
    echo "--- /dev/input event nodes ---"
    ls -la /dev/input/event* 2>&1
    echo
    echo "--- xinput list (keyboards only-ish) ---"
    xinput list 2>&1
    echo
    echo "--- kanata process ---"
    ps -ef | grep -i kanata | grep -v grep

    echo
    echo "=================================================="
    echo " STARTING daemon (holding for 3s)"
    echo "=================================================="
    python3 "$DAEMON_PY" -v >"$DAEMON_OUT" 2>&1 &
    DAEMON_PID=$!
    sleep 3

    echo "--- daemon stdout/stderr so far ---"
    cat "$DAEMON_OUT"
    echo

    echo "--- /dev/input event nodes (daemon running) ---"
    ls -la /dev/input/event* 2>&1
    echo

    echo "--- xinput list (daemon running) ---"
    xinput list 2>&1
    echo

    echo "--- libinput list-devices (kanata + chord entries) ---"
    libinput list-devices 2>&1 | grep -B1 -A8 -Ei 'kanata|chord-daemon' || echo "(no matches)"
    echo

    echo "--- /proc/bus/input/devices (kanata + chord entries) ---"
    grep -B1 -A8 -Ei 'kanata|chord-daemon' /proc/bus/input/devices || echo "(no matches)"
    echo

    echo "=================================================="
    echo " STOPPING daemon"
    echo "=================================================="
    kill "$DAEMON_PID" 2>/dev/null
    wait "$DAEMON_PID" 2>/dev/null
    echo "--- final daemon output ---"
    cat "$DAEMON_OUT"
} >"$OUT" 2>&1

echo "Diagnostic captured to $OUT"
echo "Run:  cat $OUT"
