#!/bin/sh

# In box mode the pane content grid and PTY are sized to (layout - 2) in each
# dimension so the box can occupy the pane's own edge rows/columns.

PATH=/bin:/usr/bin
TERM=screen

[ -z "$TEST_TMUX" ] && TEST_TMUX=$(readlink -f ../tmux)
TMUX="$TEST_TMUX -Ltest"
$TMUX kill-server 2>/dev/null
trap "$TMUX kill-server 2>/dev/null" 0 1 15

$TMUX -f/dev/null new -d -x 80 -y 24 || exit 1
$TMUX set -g pane-border-indicators box-all || exit 1
$TMUX splitw -h || exit 1
sleep 0.5

# Layout rectangle size of pane 0.
pw=$($TMUX display -p -t 0 '#{pane_width}')
ph=$($TMUX display -p -t 0 '#{pane_height}')

# Ask the shell in pane 0 for its actual terminal (PTY = grid) size.
$TMUX send-keys -t 0 'stty size' Enter
sleep 0.5
line=$($TMUX capture-pane -p -t 0 | grep -E '^[0-9]+ [0-9]+$' | tail -1)
[ -n "$line" ] || { echo "no stty size output"; $TMUX capture-pane -p -t 0; exit 1; }
rows=${line% *}
cols=${line#* }

[ "$cols" = "$((pw - 2))" ] || { echo "cols $cols != pane_width-2 ($((pw-2)))"; exit 1; }
[ "$rows" = "$((ph - 2))" ] || { echo "rows $rows != pane_height-2 ($((ph-2)))"; exit 1; }

$TMUX kill-server 2>/dev/null
exit 0
