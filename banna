#!/bin/bash
source ~/Repositories/scripts/essential-functions
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

function finished-p {
    if [[ "$(tail -n 1 "$dir/$1")" = "Shadi" ]]
    then
	return 0
    else
	return 1
    fi
}

function journal {
    prepare-file "$1"
    finished-p "$1" && {
	echolor yellow ":: This entry is already finished. Proceed? (Y/n) " 1
	continue_p=y
	read -r continue_p
	[[ "$continue_p" = "n" ]] && return
    }
    e "$dir/$1"
}

function view-entry {
    if [[ -e "$dir/$1" ]]
    then
	bat "$dir/$1"
    else
	echolor red ":: File ““$1”” not found."
    fi
}

function see-images {
    source ~/Repositories/dotfiles/zsh/functions
    xt "$(echo "$1" | tr -d '-')" "$HOME/Pictures/camera/"
}

while getopts 'i:v:' OPTION; do
    case "$OPTION" in
	"v") view-entry "$OPTARG" ;;
	"i") see-images "$OPTARG" ;;
	*) echolor red ":: Unknown option"; exit ;;
	esac
done
(( $OPTIND == 1 )) && {
    case "$1" in
	"today") journal "$today" ;;
	"yesterday") journal "$(date -d yesterday +%Y-%m-%d)" ;;
	*) journal "${1:-$today}" ;;
    esac
}

