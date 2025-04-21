#!/bin/bash
source ~/Repositories/scripts/essential-functions

clipdir="$HOME/Videos/clips"
[[ -z "$2" ]] && {
    echolor aquamarine ":: Eventual clip name: " 1
    read -r outname
    outname="$(kebab "$outname")"
}
echolor aquamarine ":: Beginning timestamp: " 1
read -r t_beg
echolor aquamarine ":: Ending timestamp: " 1
read -r t_end
[[ -e "$outname.mp4" ]] && {
    echolor red ":: Clobber error 01!"
    exit
}
[[ -e "$clipdir/$outname.mp4" ]] && {
    echolor red ":: Clobber error 02!"
    exit
}
ffmpeg -i "$1" -ss "$t_beg" -to "$t_end" "$clipdir"/"$outname".mp4
