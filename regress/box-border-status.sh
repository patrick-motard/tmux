#!/bin/sh

# pane-border-status top with box-all: each pane shows its own status on its
# own box top border and no pane loses its status row (nicm review issue 1).

PATH=/bin:/usr/bin
TERM=screen

[ -z "$TEST_TMUX" ] && TEST_TMUX=$(readlink -f ../tmux)
TMUX="$TEST_TMUX -Ltest"
TMUX_OUTER="$TEST_TMUX -Ltest2"
$TMUX kill-server 2>/dev/null
$TMUX_OUTER kill-server 2>/dev/null
trap "$TMUX kill-server 2>/dev/null; $TMUX_OUTER kill-server 2>/dev/null" 0 1 15

$TMUX_OUTER -f/dev/null new -d -x120 -y40 "$TMUX -f/dev/null new -x118 -y38" || exit 1
sleep 1
$TMUX set -g pane-border-indicators box-all || exit 1
$TMUX set -g pane-border-lines heavy || exit 1
$TMUX set -g pane-border-status top || exit 1
$TMUX set -g pane-border-format 'BOX#{pane_index}' || exit 1
$TMUX splitw -v || exit 1
$TMUX splitw -v || exit 1
sleep 1

out=$($TMUX_OUTER capture-pane -p)
for i in 0 1 2; do
	echo "$out" | grep -q "BOX$i" || { echo "missing status BOX$i"; echo "$out"; exit 1; }
done

$TMUX kill-server 2>/dev/null
$TMUX_OUTER kill-server 2>/dev/null
exit 0
