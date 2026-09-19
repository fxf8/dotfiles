#!/usr/bin/env python3
"""Enumerate and score QWERTY chord candidates, then greedy-assign them
to a curated list of high-value outputs (English + programming).

Meant as a *starting menu* for a kanata `defchords` layer — hand-tune
the top of the list after eyeballing it.

Usage:
    python3 chord_designer.py                # full report
    python3 chord_designer.py --chords 60    # top N chords to consider
    python3 chord_designer.py --no-assign    # skip greedy assignment

Model:
    * Hard-disallow same-finger chords (physical index-outer + index-inner
      count as the same finger).
    * Per-key cost = row_cost * finger_cost. Home < top < bottom;
      index < middle < ring < pinky; index-inner (T/G/B/Y/H/N) gets a
      stretch penalty.
    * Same-hand pair penalty scales with row-spread and finger-skip;
      pinky involvement adds a bit more. Cross-hand pairs are free.
    * 3-key chords take a small coordination surcharge.
"""

from __future__ import annotations

import argparse
from dataclasses import dataclass
from itertools import combinations


# key -> (hand, finger, row)
#   hand:   'L' | 'R'
#   finger: 0=pinky, 1=ring, 2=middle, 3=index-natural, 4=index-inner
#           (3 and 4 are the same physical finger — disallowed together)
#   row:    0=top, 1=home, 2=bottom
LAYOUT: dict[str, tuple[str, int, int]] = {
    # Top row
    "q": ("L", 0, 0), "w": ("L", 1, 0), "e": ("L", 2, 0), "r": ("L", 3, 0), "t": ("L", 4, 0),
    "y": ("R", 4, 0), "u": ("R", 3, 0), "i": ("R", 2, 0), "o": ("R", 1, 0), "p": ("R", 0, 0),
    # Home row
    "a": ("L", 0, 1), "s": ("L", 1, 1), "d": ("L", 2, 1), "f": ("L", 3, 1), "g": ("L", 4, 1),
    "h": ("R", 4, 1), "j": ("R", 3, 1), "k": ("R", 2, 1), "l": ("R", 1, 1), ";": ("R", 0, 1),
    # Bottom row
    "z": ("L", 0, 2), "x": ("L", 1, 2), "c": ("L", 2, 2), "v": ("L", 3, 2), "b": ("L", 4, 2),
    "n": ("R", 4, 2), "m": ("R", 3, 2), ",": ("R", 2, 2), ".": ("R", 1, 2), "/": ("R", 0, 2),
}

ROW_COST = {0: 1.5, 1: 1.0, 2: 2.0}
# Index (3) is baseline; index-inner (4) pays a stretch cost.
FINGER_COST = {0: 1.8, 1: 1.3, 2: 1.1, 3: 1.0, 4: 1.35}


def key_cost(k: str) -> float:
    _, finger, row = LAYOUT[k]
    return ROW_COST[row] * FINGER_COST[finger]


def same_finger(a: str, b: str) -> bool:
    ha, fa, _ = LAYOUT[a]
    hb, fb, _ = LAYOUT[b]
    if ha != hb:
        return False
    if fa == fb:
        return True
    return {fa, fb} == {3, 4}  # index-outer + index-inner share a finger


def pair_penalty(a: str, b: str) -> float:
    ha, fa, ra = LAYOUT[a]
    hb, fb, rb = LAYOUT[b]
    if ha != hb:
        return 0.0

    # Treat 3 & 4 as adjacent-finger-ish for penalty math (they're already
    # disallowed as same-finger; this branch is unreachable but keeps math clean).
    row_spread = abs(ra - rb)
    finger_skip = max(0, abs(fa - fb) - 1)

    penalty = 0.0
    if row_spread == 1:
        penalty += 0.5
    elif row_spread == 2:
        penalty += 1.3  # top+bottom on the same hand is a big vertical jump
    penalty += 0.35 * finger_skip
    if fa == 0 or fb == 0:
        penalty += 0.3  # pinky in same-hand chord
    return penalty


def chord_cost(keys: tuple[str, ...]) -> float:
    total = sum(key_cost(k) for k in keys)
    for a, b in combinations(keys, 2):
        total += pair_penalty(a, b)
    if len(keys) == 3:
        total += 0.6
    return total


def is_valid(keys: tuple[str, ...]) -> bool:
    return all(not same_finger(a, b) for a, b in combinations(keys, 2))


def enumerate_chords(sizes=(2, 3)) -> list[tuple[tuple[str, ...], float]]:
    keys = list(LAYOUT.keys())
    result: list[tuple[tuple[str, ...], float]] = []
    for size in sizes:
        for combo in combinations(keys, size):
            if is_valid(combo):
                result.append((combo, chord_cost(combo)))
    result.sort(key=lambda x: x[1])
    return result


# --- Output candidates -------------------------------------------------------
#
# Value ≈ frequency * keystrokes_saved. Hand-tuned; the greedy assignment
# is only as good as this list, so treat the numbers as seeds to edit.
# Programmer / engineer bias baked in.

@dataclass
class Target:
    text: str          # what to emit
    value: float       # rough "how much do I want a fast chord for this"
    note: str = ""     # display hint


TARGETS: list[Target] = [
    # ---- Very high frequency short English words ----
    Target("the", 10.0, "top-1 English word"),
    Target("and", 9.0),
    Target("that", 7.5),
    Target("with", 7.0),
    Target("this", 6.5),
    Target("have", 6.0),
    Target("from", 6.0),
    Target("they", 5.5),
    Target("will", 5.5),
    Target("would", 6.0),
    Target("what", 5.0),
    Target("which", 5.5),
    Target("there", 5.5),
    Target("about", 5.0),
    Target("because", 7.5, "long + very common"),
    Target("through", 6.5, "long + awkward"),
    Target("should", 5.5),
    Target("could", 5.0),
    Target("their", 5.0),
    Target("these", 5.0),
    Target("those", 4.5),
    Target("your", 5.0),
    Target("been", 4.5),

    # ---- Awkward English bigrams / trigrams ----
    Target("th", 6.0, "most common bigram"),
    Target("ch", 4.0),
    Target("sh", 3.5),
    Target("wh", 3.5),
    Target("qu", 3.5, "rare but always awkward"),
    Target("ph", 3.0),
    Target("gh", 3.0),
    Target("ck", 3.0),

    # ---- English suffixes (huge savings — attached to many words) ----
    Target("ing", 8.0, "-ing suffix"),
    Target("tion", 7.5, "-tion suffix"),
    Target("ment", 6.0),
    Target("ness", 5.0),
    Target("able", 5.5),
    Target("ible", 4.0),
    Target("ful", 4.0),
    Target("less", 4.0),
    Target("ship", 3.5),
    Target("ward", 3.0),
    Target("ally", 4.0),
    Target("ough", 4.5, "through/though/enough family"),

    # ---- English prefixes ----
    Target("un", 4.5),
    Target("re", 5.5, "very common prefix + bigram"),
    Target("pre", 4.5),
    Target("dis", 4.0),
    Target("mis", 3.0),
    Target("sub", 3.5),
    Target("inter", 4.0),
    Target("trans", 4.0),
    Target("over", 4.5),
    Target("under", 4.5),
    Target("anti", 3.0),
    Target("non", 3.0),

    # ---- Programming keywords (cross-language high value) ----
    Target("return", 9.0, "programmer bread-and-butter"),
    Target("function", 7.0),
    Target("const", 7.0),
    Target("import", 7.5),
    Target("export", 5.5),
    Target("class", 6.0),
    Target("struct", 5.5),
    Target("async", 5.0),
    Target("await", 5.0),
    Target("None", 6.0, "Python"),
    Target("True", 5.0),
    Target("False", 5.0),
    Target("null", 5.5),
    Target("void", 4.5),
    Target("static", 4.5),
    Target("public", 4.5),
    Target("private", 4.5),
    Target("impl", 5.0, "Rust"),
    Target("trait", 4.0, "Rust"),
    Target("match", 5.0),
    Target("break", 4.5),
    Target("continue", 5.0),
    Target("else", 5.5),
    Target("elif", 4.5),
    Target("while", 5.0),
    Target("catch", 4.5),
    Target("throw", 4.5),
    Target("print", 6.0),
    Target("println", 4.0),

    # ---- Programming operators / syntax digraphs ----
    Target("->", 6.0, "return type / arrow"),
    Target("=>", 6.0, "fat arrow"),
    Target("::", 5.5, "namespace / path sep"),
    Target("!=", 5.5),
    Target("==", 6.0),
    Target(">=", 4.5),
    Target("<=", 4.5),
    Target("&&", 5.0),
    Target("||", 5.0),
    Target("+=", 4.5),
    Target("-=", 4.0),
    Target(">>", 3.5),
    Target("<<", 3.5),
    Target("?.", 3.5, "optional chain"),
    Target("??", 3.5, "nullish coalesce"),
    Target("...", 4.0, "spread / rest"),

    # ---- Technical / engineering vocabulary ----
    Target("config", 5.5),
    Target("request", 5.0),
    Target("response", 5.0),
    Target("error", 6.0),
    Target("buffer", 4.5),
    Target("string", 5.5),
    Target("integer", 4.5),
    Target("boolean", 4.5),
    Target("array", 5.0),
    Target("object", 5.0),
    Target("vector", 5.0),
    Target("matrix", 4.5),
    Target("gradient", 4.0),
    Target("parameter", 5.0),
    Target("argument", 4.5),
    Target("iterator", 4.0),
    Target("callback", 4.0),
    Target("thread", 4.5),
    Target("process", 4.5),
    Target("memory", 4.0),
    Target("kernel", 4.0),
    Target("module", 5.0),
    Target("package", 4.5),
    Target("library", 4.0),
    Target("dependency", 4.5),
    Target("environment", 4.5),
    Target("variable", 5.0),
    Target("function", 5.5),  # duplicate — dedup in assignment
    Target("method", 4.5),
    Target("property", 4.5),
    Target("component", 5.0),
    Target("interface", 4.5),
    Target("database", 4.5),
    Target("schema", 4.0),
    Target("commit", 5.0),
    Target("branch", 4.5),
    Target("rebase", 4.0),
    Target("checkout", 4.0),
]


def dedup_targets(targets: list[Target]) -> list[Target]:
    seen: dict[str, Target] = {}
    for t in targets:
        prev = seen.get(t.text)
        if prev is None or t.value > prev.value:
            seen[t.text] = t
    return sorted(seen.values(), key=lambda x: -x.value)


def greedy_assign(chords: list[tuple[tuple[str, ...], float]],
                  targets: list[Target]) -> list[tuple[Target, tuple[str, ...], float]]:
    """Highest-value target grabs cheapest unused chord. Prefer shorter chords."""
    unused = sorted(chords, key=lambda x: (x[1], len(x[0])))
    result: list[tuple[Target, tuple[str, ...], float]] = []
    used_idx: set[int] = set()
    for t in targets:
        for i, (combo, cost) in enumerate(unused):
            if i in used_idx:
                continue
            used_idx.add(i)
            result.append((t, combo, cost))
            break
    return result


def fmt_chord(keys: tuple[str, ...]) -> str:
    return "+".join(keys)


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--chords", type=int, default=80,
                    help="how many top chords to print in the ranked list")
    ap.add_argument("--no-assign", action="store_true",
                    help="skip the greedy target assignment")
    ap.add_argument("--size", type=int, nargs="+", default=[2, 3],
                    help="chord sizes to enumerate (default: 2 3)")
    args = ap.parse_args()

    chords = enumerate_chords(sizes=tuple(args.size))
    targets = dedup_targets(TARGETS)

    print(f"# Ranked chord list — top {args.chords} of {len(chords)} valid chords")
    print(f"# Cost model: home>top>bottom, index>middle>ring>pinky,")
    print(f"# cross-hand free, same-hand row/finger spread penalized.")
    print(f"# {'cost':>5}  chord")
    print("# " + "-" * 30)
    for combo, cost in chords[:args.chords]:
        print(f"  {cost:5.2f}  {fmt_chord(combo)}")

    if args.no_assign:
        return

    print()
    print(f"# Greedy assignment — {len(targets)} outputs against cheapest chords")
    print(f"# Reads: <output>  <chord>  (cost)   [note]")
    print("# " + "-" * 60)
    assignments = greedy_assign(chords, targets)
    for tgt, combo, cost in assignments:
        note = f"  [{tgt.note}]" if tgt.note else ""
        print(f"  {tgt.text:<12} {fmt_chord(combo):<12} ({cost:.2f}){note}")


if __name__ == "__main__":
    main()
