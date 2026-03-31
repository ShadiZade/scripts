#!/bin/bash
source ~/Repositories/scripts/essential-functions

[[ -z "$1" ]] && {
    ep="$(eza --no-quotes -1fX --show-symlinks | sed '/^$/d' | sort | grep -Ev 'srt$|vtt$|part$' | fzf)"
} || {
    ep="$1"
}
[[ -z "$ep" ]] && {
    echolor red ":: No file selected."
    exit
}
[[ -e "$HOME/Excluding/youtube/.${ep%mp4}json" ]] && jq -r '.description' "$HOME/Excluding/youtube/.${ep%mp4}json" | bat -pp 
mpv --osd-fractions --volume=100 --volume-max=200 --alang=eng --slang=eng "$ep" || exit
fd -q donefile && {
    echolor red ":: Found a donefile, doing nothing..."
    exit
}
pwd | grep -q "$HOME/Excluding/youtube" && {
    done_exists="y"
    } || {
    fd -q "^done$" && done_exists="y" || done_exists="n"
}
[[ "$done_exists" = "n" ]] && \
    choose_no_done="$(echo -e 'Create done marker\nCreate done dir\nDo nothing' | fzf --no-input)"
case "$choose_no_done" in
    "Do nothing")
	echolor yellow ":: Doing nothing."
	exit ;;
    "Create done marker")
	donetime="$(date -Isec)"
	echo -e "$ep\n$donetime" > "./donefile-$(date -d "$donetime" +"%Y-%m-%d-%H-%M")"
	echolor green ":: Done marker created:"
	echolor white "$(cat "./donefile-$(date -d "$donetime" +"%Y-%m-%d-%H-%M")")"
	exit ;;
    "Create done dir")
	mkdir -v "done"
	fd -q "^done$" && done_exists="y" || done_exists="n"
	;;
esac
[[ "$done_exists" = "y" ]] && choose_done="$(echo -e 'Move to done\nDo nothing\nAbandon file' | fzf --no-input --prompt='Move to done? ')"
ext_alone="$(echo "$ep" | awk -F '.' '{print $NF}')"
allrelatedfiles="$(echo "$ep" | sed "s/\.$ext_alone//;s/,/‚/g")"
case "$choose_done" in
    "Move to done")
	pwd | grep -q "$HOME/Excluding/youtube" && {
	    {
		echo -ne "$allrelatedfiles,"
		echo -ne "$(jq '.channel' "$HOME/Excluding/youtube/.$allrelatedfiles".json),"
		echo  -e "$(date -Isec)"
	    } >> "$HOME"/Misc/Backups/video/watch-history-youtube.csv
	    mv -v "$allrelatedfiles"* "$HOME/Excluding/youtube/done/"
	    mv -v "$HOME/Excluding/youtube/.$allrelatedfiles".json "$HOME/Excluding/youtube/done/$allrelatedfiles.json" 2> /dev/null
	    echolor green ":: The file ““$allrelatedfiles””\n:: has been logged into the YouTube record"
	} || {
	    mv -v "$allrelatedfiles"* .done/
	    echo -e "$allrelatedfiles,$(date -Isec)" >> "$HOME"/Misc/Backups/video/watch-history-general.csv
	    echolor green ":: The file ““$allrelatedfiles””\n:: has been logged into the general record"
	}
	;;
    "Do nothing")
	echolor yellow ":: Nothing was done"
	;;
    "Abandon file")
	pwd | grep -q "$HOME/Excluding/youtube" && {
	    mv -v "$allrelatedfiles"* "$HOME/Excluding/youtube/done/"
	    mv -v "$HOME/Excluding/youtube/.$allrelatedfiles".json done/"$allrelatedfiles".json 2> /dev/null
	    echolor yellow ":: The file ““$allrelatedfiles””\n:: has been abandoned"
	    } || {
	    mv -v "$allrelatedfiles"* done/ 
	    mv -v ".$allrelatedfiles".json done/"$allrelatedfiles".json 2> /dev/null
	    echolor yellow ":: The file ““$allrelatedfiles””\n:: has been abandoned"
	}
	;;
esac
