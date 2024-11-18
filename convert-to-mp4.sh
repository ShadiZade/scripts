#!/bin/bash
source ~/Repositories/scripts/essential-functions

working="$1"
[ -z "$working" ] && echo -e "\033[31m:: Missing argument!\033[0m" && return

function if-gif {
    echolor yellow ":: Converting gif..."
    working="$(echo "$working" | sed 's/\.gif$//g')"
    ffmpeg -i "$working".gif -movflags faststart -pix_fmt yuv420p -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" "$working".mp4
    mpv --loop=inf "$working".mp4
    agreedel="$(echo -e "yes\nno" | fzf --prompt='Delete original? ')"
    [ "$agreedel" = "yes" ] && rm -vf "$working".gif
}

function if-webm {
    echolor yellow ":: Converting webm..."
    working="$(echo "$working" | sed 's/\.webm$//g')"
    ffmpeg -i "$working".webm "$working".mp4
    mpv --loop=inf "$working".mp4
    agreedel="$(echo -e "yes\nno" | fzf --prompt='Delete original? ')"
    [ "$agreedel" = "yes" ] && rm -vf "$working".webm
}

function if-m4v {
    echolor yellow ":: Converting m4v..."
    working="$(echo "$working" | sed 's/\.m4v$//g')"
    ffmpeg -i "$working".m4v "$working".mp4
    mpv --loop=inf "$working".mp4
    agreedel="$(echo -e "yes\nno" | fzf --prompt='Delete original? ')"
    [ "$agreedel" = "yes" ] && rm -vf "$working".m4v
}


file --extension "$working" | grep -q "gif$" && if-gif
file --extension "$working" | grep -q "webm$" && if-webm
file --extension "$working" | grep -q "m4v$" && if-m4v
# file --extension "$working" | grep -q "gif$|webm$|m4v$" || {



