#!/bin/sh

# "box" draws only the active pane's border; "box-all" draws every pane's.
# box-all must therefore render strictly more vertical border glyphs than box.

PATH=/bin:/usr/bin
TERM=screen

[ -z "$TEST_TMUX" ] && TEST_TMUX=$(readlink -f ../tmux)
TMUX="$TEST_TMUX -Ltest"
TMUX_OUTER="$TEST_TMUX -Ltest2"
$TMUX kill-server 2>/dev/null
$TMUX_OUTER kill-server 2>/dev/null
trap "$TMUX kill-server 2>/dev/null; $TMUX_OUTER kill-server 2>/dev/null" 0 1 15

V=$(printf '\342\224\203')   # heavy vertical box-drawing glyph

$TMUX_OUTER -f/dev/null new -d -x80 -y24 "$TMUX -f/dev/null new -x78 -y22" || exit 1
sleep 1
$TMUX set -g pane-border-lines heavy || exit 1
$TMUX splitw -h || exit 1
sleep 1

$TMUX set -g pane-border-indicators box || exit 1
sleep 1
count_box=$($TMUX_OUTER capture-pane -p | grep -o "$V" | wc -l | tr -d ' ')

$TMUX set -g pane-border-indicators box-all || exit 1
sleep 1
count_all=$($TMUX_OUTER capture-pane -p | grep -o "$V" | wc -l | tr -d ' ')

[ "$count_box" -gt 0 ] || { echo "box: no active box drawn"; $TMUX_OUTER capture-pane -p; exit 1; }
[ "$count_all" -gt "$count_box" ] || { echo "box-all ($count_all) not > box ($count_box)"; $TMUX_OUTER capture-pane -p; exit 1; }

$TMUX kill-server 2>/dev/null
$TMUX_OUTER kill-server 2>/dev/null
exit 0
