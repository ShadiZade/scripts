#!/bin/bash
source ~/Repositories/scripts/essential-functions

[[ -z "$2" || "$2" = '.' ]] && {
    outname="$(random-word 4)"
    # leave $2 empty for a randomized filename
} || {
    outname="$(kebab "$2")"
}

[[ -n "$3" ]] && {
    [[ -d "$3" ]] && {
	clipdir="$3"
    } || {
	echolor red ":: No such directory!"
	exit 1
    }
} || {
    [[ "$2" = '.' ]] && {
	clipdir='.'
    } || {
	clipdir="$HOME/Videos/clips"
    }
}

# $2 = '.' and $3 = '' is an alias for $2 = '' and $3 = '.'

echolor green ":: outputting as ““$clipdir/$outname.mkv””"
echolor aquamarine ":: Beginning timestamp: " 1
read -r t_beg
echolor aquamarine ":: Ending timestamp: " 1
read -r t_end
[[ -e "$outname.mp4" ]] && {
    echolor red ":: Clobber error 01!"
    exit 1
}
[[ -e "$clipdir/$outname.mp4" ]] && {
    echolor red ":: Clobber error 02!"
    exit 1
}
ffmpeg -i "$1" -map 0 -c:v libsvtav1 -ss "$t_beg" -to "$t_end" "$clipdir"/"$outname".mkv
