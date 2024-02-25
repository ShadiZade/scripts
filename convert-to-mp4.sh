#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh

working="$1"
[ -z "$working" ] && echo -e "\033[31m:: Missing argument!\033[0m" && return

function if-gif {
    working="$(echo "$working" | sed 's/\.gif$//g')"
    ffmpeg -i "$working".gif -movflags faststart -pix_fmt yuv420p -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" "$working".mp4
    mpv --loop=inf "$working".mp4
    agreedel="$(echo -e "yes\nno" | fzf --prompt='Delete original? ')"
    [ "$agreedel" = "yes" ] && rm -vf "$working".gif
}

function if-webm {
    working="$(echo "$working" | sed 's/\.webm$//g')"
    ffmpeg -i "$working".webm "$working".mp4
    mpv --loop=inf "$working".mp4
    agreedel="$(echo -e "yes\nno" | fzf --prompt='Delete original? ')"
    [ "$agreedel" = "yes" ] && rm -vf "$working".webm
}


file --extension "$working" | grep -q "gif" && if-gif
file --extension "$working" | grep -q "webm" && if-webm
file --extension "$working" | grep -q "gif|webm" || exit


