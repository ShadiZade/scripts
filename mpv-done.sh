#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh

[[ -z "$1" ]] && {
    ep="$(eza --no-quotes -1fX --show-symlinks | sed '/^$/d' | sort | grep -Ev 'srt$|vtt$|part$' | fzf)"
} || {
    ep="$1"
}
[[ -z "$ep" ]] && {
    echolor red ":: No file selected."
    exit
}
mpv --osd-fractions --alang=eng --slang=eng "$ep" || exit
fd -q donefile && exit
fd -q "^done$" && done_exists="y" || done_exists="n"
[[ "$done_exists" = "n" ]] && \
    choose_no_done="$(echo -e 'Create done marker\nCreate done dir\nDo nothing' | fzf)"
case "$choose_no_done" in
    "Do nothing")
	echo ":: Doing nothing."
	exit ;;
    "Create done marker")
	echo "$ep is done on $(date +"%Y-%m-%d %H:%M")." > ./"donefile-$(date +"%Y-%m-%d-%H-%M")"
	echo ":: Done marker created."
	exit ;;
    "Create done dir")
	mkdir -v "done"
	fd -q "^done$" && done_exists="y" || done_exists="n"
	;;
esac
[[ "$done_exists" = "y" ]] && choose_done="$(echo -e 'yes\nno' | fzf --prompt='Move to done? ')"
ext_alone="$(echo "$ep" | awk -F '.' '{print $NF}')"
allrelatedfiles="$(echo "$ep" | sed "s/\.$ext_alone//")"
[[ "$choose_done" = "yes" ]] && mv -v "$allrelatedfiles"* done/ 
