#!/bin/sh

# Test box border mode basic functionality (option plumbing + sizing).

PATH=/bin:/usr/bin
TERM=screen

[ -z "$TEST_TMUX" ] && TEST_TMUX=$(readlink -f ../tmux)
TMUX="$TEST_TMUX -Ltest"
$TMUX kill-server 2>/dev/null

$TMUX -f/dev/null new -d
$TMUX set -g pane-border-indicators box
[ "$($TMUX show -gv pane-border-indicators)" = "box" ] || exit 1

$TMUX set -g pane-border-indicators box-all
[ "$($TMUX show -gv pane-border-indicators)" = "box-all" ] || exit 1

$TMUX set -g pane-border-indicators off
[ "$($TMUX show -gv pane-border-indicators)" = "off" ] || exit 1

$TMUX kill-server 2>/dev/null
exit 0
