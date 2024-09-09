#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh
cd "$HOME"/.local/share/user-scripts/sounds
function get-from-catalogue {
    cat ~/Repositories/scripts/sound-effects.sh \
	| grep "^# $1" \
	| sed "s/^# $1//g;s/^ //g"
}
function a {
    mpv --really-quiet --profile=fast --no-audio-display $(get-from-catalogue "$1") --volume="${2:-60}"
}

function a10 {
    mpv --really-quiet --profile=fast --no-audio-display --loop=10 "$(get-from-catalogue "$1")"
}

function ainf {
    mpv --really-quiet --profile=fast --no-audio-display --loop=inf "$(get-from-catalogue "$1")"
}

case "$1" in
    "ten-bloops") a10 001 ;;
    "glass-hit") ainf 002 ;;
    "bruh") a 003 ;;
    "jumpy-laser") a 007 40;;
    "d2a-d2i") a 008 70;;
    "done") a 009;;
    "too-low") a 010 80;;
    *) a 002 ;;
esac

# SOUND CATALOGUE
# 001 bloops.oga
# 002 glass-hit.wav
# 003 bruh.mp3
# 004 jalastram-jump.wav
# 005 owlstorm-retro-laser.wav
# 006 julien-laser.wav
# 007 jalastram-jump.wav owlstorm-retro-laser.wav julien-laser.wav
# 008 d2a-d2i.mp3
# 009 angelic-ding.wav
# 010 too-low.mp3

### TODO system check for [[ -e ]] sound catalogue files
