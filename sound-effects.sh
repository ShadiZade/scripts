#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh
cd "$HOME"/.local/share/user-scripts/sounds
function get-from-catalogue {
    cat "$HOME"/.local/share/user-scripts/sound-catalogue \
	| grep -m 1 -- "^$1," \
	| awk -F ',' '{print $2}'
}

function play {
    mpv --really-quiet --profile=fast --no-audio-display $(get-from-catalogue "$1") --volume="${2:-80}" --loop="${3:-0}"
}
case "$1" in
    "ten-bloops") play sound-001 150 10 ;;
    "glass-hit") play sound-002 '' inf ;;
    "bruh") play sound-003 ;;
    "jumpy-laser") play sound-007;;
    "d2a-d2i") play sound-008;;
    "done") play sound-009;;
    "too-low") play sound-010 110;;
    "adapter-removed") play sound-011 100 2 ;;
    "adapter-connect") play sound-012 100 ;;
    *) play sound-002 ;;
esac
