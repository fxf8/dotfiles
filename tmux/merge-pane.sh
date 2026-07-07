#!/usr/bin/env sh
# Merge current pane into window $1.
# $2 = split flag for join-pane (h = vertical divider, v = horizontal divider).
# If the target window doesn't exist, create it containing only this pane.
# Always follows the moved pane to the destination window.

target="$1"
split="$2"

if tmux list-windows -F '#I' | grep -qx "$target"; then
    target_id=$(tmux list-windows -F '#{window_index} #{window_id}' | awk -v t="$target" '$1 == t {print $2}')
    tmux join-pane -"$split" -t ":$target"
    tmux select-window -t "$target_id"
else
    tmux break-pane -t ":$target"
fi
