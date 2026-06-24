#!/usr/bin/env sh
# Merge current pane into window $1.
# $2 = split flag for join-pane (h = vertical divider, v = horizontal divider).
# If the target window doesn't exist, create it containing only this pane.

target="$1"
split="$2"

if tmux list-windows -F '#I' | grep -qx "$target"; then
    tmux join-pane -"$split" -t ":$target"
else
    tmux break-pane -d -t ":$target"
fi
