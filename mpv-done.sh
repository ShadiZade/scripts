#!/bin/bash

[ -z "$1" ] && return
command mpv "$1"
fd -q done && done_exists="y" || done_exists="n"
[ "$done_exists" = "n" ] && choose_no_done="$(echo -e 'Create done marker\nCreate done dir' | fzf --prompt='No done dir exists, what to do?')"
[ "$choose_no_done" = "Create done marker" ] && echo "$1 is done" > ./".donefile"
[ "$choose_no_done" = "Create done dir" ] && mkdir -v "done"
fd -q done && done_exists="y" || done_exists="n"
[ "$done_exists" = "y" ] && choose_done="$(echo -e 'yes\nno' | fzf --prompt='Move to done?')"
[ "$choose_done" = "yes" ] && mv -v "$1" done/
