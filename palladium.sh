#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh
loc="$HOME/Athenaeum"
ix="$usdd/athenaeum-index.csv"
bkp="$HOME/Misc/Backups/athenaeum"

function open-book {
    [[ -z "$sld_ttl" ]] && sld_ttl="$(xsv select title "$ix" | sed 1d | sort | uniq | fzf)"
    [[ -z "$sld_ttl" ]] && {
	echolor red ":: Nothing selected."
	return
    }
    # checks if more than 1 entry has the same title and prompts for subtitle
    if [[ "$(xsv select title "$ix" | grep -c "$sld_ttl")" -gt 1 ]]
    then
	sld_sbttl="$(xsv search -s title "$sld_ttl" "$ix" | xsv select volume,subtitle | sed 1d | fzf | xsv select 2 | tr -d '"')"
	[[ -z "$sld_sbttl" ]] && {
	    echolor red ":: Nothing selected."
	    return
	}
    	sld_fnm="$loc/$(xsv search -s title "$sld_ttl" "$ix" | xsv search -s subtitle "$sld_sbttl" | xsv select filename | sed -n 2p)"
	# checks if more than 1 entry has the same title-subtitle combination and prompts for edition number
	[[ "$(xsv search -s title "$sld_ttl" "$ix" | xsv search -s subtitle "$sld_sbttl" | wc -l)" -gt 2 ]] && {
	    sld_ed="$(xsv search -s title "$sld_ttl" "$ix" | xsv search -s subtitle "$sld_sbttl" | xsv select edition | sed 1d | fzf -p 'Select edition: ')"
	[[ -z "$sld_ed" ]] && {
	    echolor red ":: Nothing selected."
	    return
	}
	sld_fnm="$loc/$(xsv search -s title "$sld_ttl" "$ix" | xsv search -s subtitle "$sld_sbttl" | xsv search -s edition "$sld_ed" | xsv select filename | sed -n 2p)"
	}
    else
	# this is activated only if the title is unique
	sld_fnm="$loc/$(xsv search -s title "$sld_ttl" "$ix" | xsv select filename | sed -n 2p)"
    fi
    zathura -P 1 "$sld_fnm" 2>/dev/null
}

function backup-index {
    cmp -s "$ix" "$bkp/$(eza -1f "$bkp" | tail -n 1)" || {
	echolor yellow ":: New entries detected. Backing up index..."
	cp -- "$ix" "$bkp"/athenaeum-index-$(date-string).csv
    }
}

function search-by {
    case "$(echo -e "Author\nCountry\nLanguage\nPublisher\nType\nYear" | fzf)" in
	"Author") sterm=author ;;
	"Country") sterm=country ;;
	"Language") sterm=language ;;
	"Publisher") sterm=publisher ;;
	"Type") sterm=type ;;
	"Year") sterm=first_published ;;
	*) echolor red ":: No search parameter chosen."
	   return
	   ;;
    esac
    filterer="$(xsv select "$sterm" "$ix" | sed 1d | sed '/""/d' | tr -d '"' | sort | uniq | fzf)"
    sld_ttl="$(xsv select title,"$sterm" "$ix" | xsv search -s "$sterm" "$filterer" | xsv select title | sed 1d | sort | uniq | fzf)"
    export sld_ttl
    open-book
}

function dup-check {
    # check for duplicated lines
    echo
}

function add-entry {
    IFS=$'\n'
    for j in $(xsv headers -j "$ix")
    do
	echo
    done
}

function index-sorter {
    # reorder index file by book title
    echo
}

backup-index
case "$1" in
    "filter") search-by ;;
    *) open-book ;;
esac
