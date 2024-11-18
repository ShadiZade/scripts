#!/bin/bash
source ~/Repositories/scripts/essential-functions

clipdir="$HOME/Videos/clips"

function ask-for-timestamps {
    echolor yellow ":: Beginning timestamp:"
    echolor blue "- Hour: " 1
    read -r beg_hour
    echolor blue "- Mins: " 1
    read -r beg_mins
    echolor blue "- Secs: " 1
    read -r beg_secs
    echolor yellow ":: Ending timestamp:"
    echolor blue "- Hour: " 1
    read -r end_hour
    echolor blue "- Mins: " 1
    read -r end_mins
    echolor blue "- Secs: " 1
    read -r end_secs
    export t_beg="${beg_hour}:${beg_mins}:${beg_secs}"
    export t_end="${end_hour}:${end_mins}:${end_secs}"
}

[[ -z "$2" ]] && {
    echolor red ":: Input error."
    exit
}
outname="$(output-kebabized-string "$2")"
[[ -e "${outname}.mp4" ]] && {
    echolor red ":: Clobber error 01!"
    exit
}
[[ -e "$clipdir/$outname.mp4" ]] && {
    echolor red ":: Clobber error 02!"
    exit
}
ask-for-timestamps
ffmpeg -i "$1" -ss "$t_beg" -to "$t_end" "$clipdir"/"$outname".mp4
