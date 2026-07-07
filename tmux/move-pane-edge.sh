#!/usr/bin/env sh
# Move current pane to an edge of the window, full-span.
# Mirrors nvim <C-w>{H,J,K,L}.
# Usage: move-pane-edge.sh {h,j,k,l}

direction="$1"

current=$(tmux display-message -p '#{pane_id}')
other=$(tmux list-panes -F '#{pane_id}' | grep -v "^${current}$" | head -1)

[ -z "$other" ] && exit 0

case "$direction" in
    h) tmux move-pane -h -b -f -s "$current" -t "$other" ;;
    l) tmux move-pane -h    -f -s "$current" -t "$other" ;;
    k) tmux move-pane -v -b -f -s "$current" -t "$other" ;;
    j) tmux move-pane -v    -f -s "$current" -t "$other" ;;
esac
