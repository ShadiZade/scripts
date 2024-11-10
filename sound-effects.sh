#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh
cd "$HOME"/.local/share/user-scripts/sounds || exit 1
function catalogue {
    cat "$HOME"/.local/share/user-scripts/sfx-catalogue.csv         \
	| grep -m 1 -- "^$1,"                                       \
	| awk -F ',' '{print "--volume="$3" --loop="$4" -- "$2}'
}

function play-sound {
    mpv --really-quiet --profile=fast --no-audio-display $(catalogue "$1")
}

function view-sounds {
    while true
    do
	sound="$(cat "$HOME"/.local/share/user-scripts/sfx-catalogue.csv | sed 1d | awk -F ',' '{print $1}' | fzf)"
	echo $sound
	play-sound "$sound"
    done
}

while getopts 'movra:d' OPTION; do
    case "$OPTION" in
	"v") view-sounds ;;
	esac
done
(( $OPTIND == 1 )) && play-sound "${1:-one-bloop}"
