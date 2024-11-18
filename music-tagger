#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh


[[ -n "$1" ]] && {
    [[ ! -e "$1" ]] && {
	echolor red ":: File ““$1”” does not exist."
	exit 1
    }
    echolor yellow ":: Current metadata for this file:"
    echolor white "$(tagutil -- "$(realpath "$1")")"
    echolor yellow "---"
}   

echolor green "Title: " 1
read -r title
echolor violet "Artist: " 1
read -r artist
echolor orange "Genre: " 1
read -r genre

if [[ -z "$1" ]]
then
    wf="$(eza -1f | ifne fzf)"
else
    wf="$1"
fi


[[ -z "$wf" ]] && return 1

[[ ! -z "$title" ]] && tagutil add:title="$title" "$wf"
[[ ! -z "$artist" ]] && tagutil add:artist="$artist" "$wf"
[[ ! -z "$genre" ]] && tagutil add:genre="$genre" "$wf"

