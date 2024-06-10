#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh
loc="$HOME/Athenaeum"
ix="$usdd/athenaeum-index.csv"
bkp="$HOME/Misc/Backups/athenaeum"

function open-book {
    [[ -z "$sld_ttl" ]] && sld_ttl="$(xsv select title "$ix" | tr -d '"' | sed 1d | sort | uniq | fzf)"
    [[ -z "$sld_ttl" ]] && {
	echolor red ":: Nothing selected."
	return
    }
    # checks if more than 1 entry has the same title and prompts for volume
    if [[ "$(xsv select title "$ix" | grep -c "$sld_ttl")" -gt 1 ]]
    then
	sld_vol="$(xsv search -s title "$sld_ttl" "$ix" | xsv select volume,subtitle | sed 1d | fzf | xsv select 1 | tr -d '"')"
	[[ -z "$sld_vol" ]] && {
	    echolor red ":: Nothing selected."
	    return
	}
    	sld_fnm="$loc/$(xsv search -s title "$sld_ttl" "$ix" | xsv search -s volume "$sld_vol" | xsv select filename | sed -n 2p)"
	# checks if more than 1 entry has the same title-volume combination and prompts for edition number
	[[ "$(xsv search -s title "$sld_ttl" "$ix" | xsv search -s volume "$sld_vol" | wc -l)" -gt 2 ]] && {
	    sld_ed="$(xsv search -s title "$sld_ttl" "$ix" | xsv search -s volume "$sld_vol" | xsv select edition | sed 1d | fzf -p 'Select edition: ')"
	    [[ -z "$sld_ed" ]] && {
	    echolor red ":: Nothing selected."
	    return
	}
	sld_fnm="$loc/$(xsv search -s title "$sld_ttl" "$ix" | xsv search -s volume "$sld_vol" | xsv search -s edition "$sld_ed" | xsv select filename | sed -n 2p)"
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
    sld_ttl="$(xsv select title,"$sterm" "$ix" | xsv search -s "$sterm" "$filterer" | xsv select title | tr -d '"' | sed 1d | sort | uniq | fzf)"
    export sld_ttl
    open-book
}

function dup-check {
    # check for duplicated lines
    cat "$ix" | sort | uniq -c | grep -qv "^      1" && {
	IFS=$'\n'
	for j in $(cat "$ix" | sort | uniq -c | grep -v "^      1" | xsv select 2)
	do
	    echolor red ":: Duplication detected in index file: ““$j””"
	done
	exit
    }
}

function add-entry {
    [[ -z "$1" ]] && {
	echolor red ":: No filename chosen."
	return
    }
    [[ -e "$1" ]] || {
	echolor red ":: This file does not exist."
	return
    }
    nix="$HOME/Desktop/ath-new-entry-$(date-string).csv"
    touch "$nix"
    IFS=$'\n'
    sed -n 1p "$ix" >> "$nix"
    for j in $(xsv headers -j "$ix" | sed '/^filename$/d')
    do
	echolor green "$j: " 1
	read -r value
	value="$(echo "$value" | sed "s/'/’/g")"
	echo "$value" | grep -q ',' && value="\"$value\""
	echo -n "$value," >> "$nix"
    done
    echo -n "$(basename "$1")" >> "$nix"
    csvlens "$nix"
    echolor yellow ":: Continue? (y/N) " 1
    read -r continue_p
    [[ "$continue_p" != "y" ]] && {
	echolor red ":: Exiting."
	move-to-trash "$nix"
	return
    }
    xsv cat rows "$ix" "$nix" | xsv sort -s title > "$ix"-new 
    move-to-trash "$nix"
    move-to-trash "$ix"
    mv "$ix"-new "$ix"
    mv "$1" "$HOME/Athenaeum/"
    backup-index
}

function index-sorter {
    # reorder index file by book title
    echo
}

backup-index
dup-check
case "$1" in
    "filter") search-by ;;
    "add") add-entry "$2" ;;
    *) open-book ;;
esac
