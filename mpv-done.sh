#!/bin/bash

[ -z "$1" ] && return
command mpv "$1" || exit
fd -q done && done_exists="y" || done_exists="n"
[ "$done_exists" = "n" ] && choose_no_done="$(echo -e 'Create done marker\nCreate done dir\nDo nothing' | fzf --prompt='No done dir exists, what to do? ')"
[ "$choose_no_done" = "Do nothing" ] && echo ":: Doing nothing." && exit
[ "$choose_no_done" = "Create done marker" ] && echo "$1 is done on $(date +"%Y-%m-%d %H:%M")." > ./".donefile" && echo ":: Done marker created."
[ "$choose_no_done" = "Create done dir" ] && mkdir -v "done"
fd -q done && done_exists="y" || done_exists="n"
[ "$done_exists" = "y" ] && choose_done="$(echo -e 'yes\nno' | fzf --prompt='Move to done? ')"
ext_alone="$(echo $1 | awk -F '.' '{print $NF}')"
allrelatedfiles="$(echo $1 | sed "s/\.$ext_alone//")"
[ "$choose_done" = "yes" ] && mv -v "$allrelatedfiles"* done/
