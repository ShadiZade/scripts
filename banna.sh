#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh
dir="$HOME/Misc/diary"
today="$(date +%Y-%m-%d)"

function e {
    emacsclient -nw -a emacs "$1"
}

function prepare-file {
    file="$dir/$1"
    if [[ ! -e "$file" ]] || [[ "$(du "$file" | awk '{print $1}')" -eq 0 ]]
    then
	echo "$1" >> "$file"
	echo "(Writing on $(date +%Y-%m-%d\ %H:%m))" >> "$file"
	echo -e "$(for j in $(eza -1f "$dir"); do sed -n 3p "$dir/$j"; done)" | sort | uniq | sed '/^-/d' | fzf >> "$file"
	echolor yellow-purple ":: File ““$1”” created."
    fi
}

    
function journal {
    prepare-file "$1"
    e "$1"
}

journal "$today"
