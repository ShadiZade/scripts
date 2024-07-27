#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh
fav="$usdd/favored-fonts.csv"
lang=''

function select-lang {
    [[ -z "$lang" ]] && {
	export lang="$(xsv select 1 "$fav" | sed 1d | sort | uniq | fzf)"
    }
}

function get-font {
    select-lang
    xsv search -s 1 "$lang" "$fav" | xsv select 2 | sed 1d | sort | uniq | ifne fzf
}

function add-font {
    select-lang
    echo "$lang,$1" >> "$fav"
}

while getopts 'l:a:ve' OPTION; do
    case "$OPTION" in
	"l") lang="$OPTARG"
	     get-font
	     ;;
	"a") add-font "$OPTARG";;
	"v") xsv sort -s 1 "$fav" | csvlens ;;
	"e") eval "$EDITOR" "$fav" ;;
	*) echolor red ":: Unknown option"
	   exit
	   ;;
    esac
done
(( $OPTIND == 1 )) && get-font

	   
