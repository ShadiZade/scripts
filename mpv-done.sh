#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh

[ -z "$1" ] \
    && ep="$(eza -f1 --no-quotes | grep -Ev 'srt$|vtt$|part$' | fzf)" \
	|| ep="$1"
[ -z "$ep" ] \
    && echo -e "\033[33m:: No file selected.\033[0m" \
    && exit
mpv --alang=eng --slang=eng "$ep" || exit
fd -q donefile && exit
fd -q "^done" && done_exists="y" || done_exists="n"
[ "$done_exists" = "n" ] && choose_no_done="$(echo -e 'Create done marker\nCreate done dir\nDo nothing' | fzf --prompt='No done dir exists, what to do? ')"
[ "$choose_no_done" = "Do nothing" ] && echo ":: Doing nothing." && exit
[ "$choose_no_done" = "Create done marker" ] && echo "$ep is done on $(date +"%Y-%m-%d %H:%M")." > ./"donefile-$(date +"%Y-%m-%d-%H-%M")" && echo ":: Done marker created." && exit
[ "$choose_no_done" = "Create done dir" ] && mkdir -v "done"
fd -q done && done_exists="y" || done_exists="n"
[ "$done_exists" = "y" ] && choose_done="$(echo -e 'yes\nno' | fzf --prompt='Move to done? ')"
ext_alone="$(echo "$ep" | awk -F '.' '{print $NF}')"
allrelatedfiles="$(echo "$ep" | sed "s/\.$ext_alone//")"
[ "$choose_done" = "yes" ] && mv -v "$allrelatedfiles"* done/
