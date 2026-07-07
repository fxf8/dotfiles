#!/usr/bin/env sh
# Swap current window with its neighbor and follow it.
# $1 = -1 (left) or +1 (right) — passed to swap-window -t.

direction="$1"
id=$(tmux display-message -p '#{window_id}')
tmux swap-window -t "$direction" && tmux select-window -t "$id"
