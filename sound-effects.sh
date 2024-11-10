#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh
cd "$HOME"/.local/share/user-scripts/sounds || exit 1
function catalogue {
    cat "$HOME"/.local/share/user-scripts/sfx-catalogue.csv         \
	| grep -m 1 -- "^$1,"                                     \
	| awk -F ',' '{print "--volume="$3" --loop="$4" -- "$2}'
}

mpv --really-quiet --profile=fast --no-audio-display $(catalogue "$1") || exit 1
