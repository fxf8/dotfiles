# Chord mappings for chord_daemon.py.
#
# Hold PrtSc, type the sequence, release PrtSc to emit the value.
# Order matters. Sequence keys should be plain letters/digits.
# The output string can contain any printable character.
#
# After editing, reload without restart:
#   systemctl --user reload chord-daemon
# or:
#   pkill -HUP -f chord_daemon.py

MAPPINGS: dict[str, str] = {
    " ":   " ",
    "a":   "and",
    "at":  "ation",
    "t":   "the",
    "te":  "there",
    "ti":  "tion",
    "":  "tion",
    "i":   "is",
    "e":   "end",
    "ati": "action",
    "f":   "for",
    "fa":  "fast",
    "far": "faster",
    "m":   "may",
    "mi":  "might",
    "apr": "appear",
    "n":   "not",
    "nc":  "ance",
}
