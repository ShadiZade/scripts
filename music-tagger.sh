#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh

read -r -p "Title: " title
read -r -p "Artist: " artist
read -r -p "Genre: " genre

if [[ -z "$1" ]]
then
    wf="$(eza -1f | ifne fzf)"
else
    wf="$1"
fi

[[ -z "$wf" ]] && return 1

[[ ! -z "$title" ]] && taffy -t "$title" "$wf"
[[ ! -z "$artist" ]] && taffy -r "$artist" "$wf"
[[ ! -z "$genre" ]] && taffy -g "$genre" "$wf"

