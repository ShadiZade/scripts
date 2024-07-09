#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh
loc="$HOME/Athenaeum"
ix="$usdd/athenaeum-index.csv"
bkp="$HOME/Misc/Backups/athenaeum"
all_attr=(type title subtitle author volume edition first_published year publisher country language trans_p original_lang transor filename)



function dup-check {
    if [[ "$(xsv search -s "$1" "$2" "$ix" | xsv select "$1" | sed 1d | wc -l)" -gt 1 ]]
    then
	return 0
    else
	return 1
    fi
}

function dupper {
    # dupper field_already_queried other_field_to_query term fields_to_display_comma_separated order_of_field
    # dupper title volume XYZ volume,subtitle 1
    # e.g. can be run if two books titled XYZ are found (in order to choose by volume)
    dup_field="$1"
    alt_field="$2"
    dup_term="$3"
    view_fields="$4"
    alt_field_order="$5"
    [[ -z "$view_fields" ]] && view_fields="$alt_field"
    [[ -z "$alt_field_order" ]] && alt_field_order=1
    xsv search -s "$dup_field" "$dup_term" "$ix" | xsv select "$view_fields" | sed 1d | fzf | xsv select "$alt_field_order"
}

function best-algo {
    # best methods to deal with duplicates
    best=(volume volume,subtitle language language,trans_p author author edition edition,year publisher publisher country country,language transor transor,language filename filename)
    attr_diff=()
    for j in $(xsv headers -j "$ix")
    do
	if [[ "$(xsv search -s "$1" "$2" "$ix" | xsv select "$j" | sed 1d | sort | uniq | wc -l)" -gt 1 ]]
	then
	    attr_diff+=("$j")
	fi
    done
    [[ -z "$attr_diff" ]] && return 1
}

function choose-book {
    [[ -z "$sld_ttl" ]] && sld_ttl="$(xsv select title "$ix" | tr -d '"' | sed 1d | sort | uniq | fzf)"
    [[ -z "$sld_ttl" ]] && {
	echolor red ":: Nothing selected."
	return 1
    }
    if $(dup-check title "$sld_ttl")
    then
	best-algo title "$sld_ttl"
	i=-1
	for j in ${best[@]}
	do
	    ((i++))
	    [[ $((i%2)) -eq 1 ]] && continue
	    if $(echo "${attr_diff[@]}" | grep -q "$j")
	    then
		chosen_best=${best[$i]}
		chosen_best_config=${best[((i+1))]}
		break
	    fi
	done
	dup_out="$(dupper title "$chosen_best" "$sld_ttl" "$chosen_best_config" 1)"
	[[ -z "$dup_out" ]] && {
	    echolor red ":: Nothing selected."
	    return 1
	}
	sld_fnm="$loc/$(xsv search -s title "$sld_ttl" "$ix" | xsv search -s "$chosen_best" "$dup_out" | xsv select filename | sed -n 2p)"
    else
	sld_fnm="$loc/$(xsv search -s title "$sld_ttl" "$ix" | xsv select filename | sed -n 2p)"
    fi
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

function dup-check-in-index {
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
    nix="/tmp/ath-new-entry-$(date-string).csv"
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
    echolor yellow ":: Continue? (Y/n) " 1
    read -r continue_p
    [[ "$continue_p" = "n" ]] && {
	echolor red ":: Exiting."
	return
    }
    xsv cat rows "$ix" "$nix" | xsv sort -s title > "$ix"-new 
    rm -f "$ix"
    mv "$ix"-new "$ix"
    mv "$1" "$HOME/Athenaeum/"
    continue_p=""
    echolor yellow ":: Create symlink? (y/N) " 1
    read -r continue_p
    [[ "$continue_p" = "y" ]] && {
	ln -s ~/Athenaeum/"$(basename "$1")" . && \
	    echolor green ":: Symlink created."
    }
    backup-index
}

function index-sorter {
    # reorder index file by book title
    echo
}

function symlinker {
    choose-book || return 1
    ln -sf "$sld_fnm" . &&\
	echolor green ":: Book ““$sld_ttl”” symlinked here!"
}

function open-book {
    choose-book || return 1
    zathura "$sld_fnm" 2>/dev/null
}

function show-info {
    choose-book || return 1
    base_fnm="$(basename -- "$sld_fnm")"
    xsv search -s filename "$base_fnm" "$ix" | xsv flatten
}

[[ -z "$ix" ]] && {
    echolor red ":: Index variable not set!"
    exit
}
backup-index
dup-check-in-index
case "$1" in
    "by") search-by ;;
    "link") symlinker ;;
    "add") add-entry "$2" ;;
    "info") show-info ;;
    *) open-book ;;
esac
