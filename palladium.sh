#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh
loc="$HOME/Athenaeum"
ix="$usdd/athenaeum-index.csv"
bkp="$HOME/Misc/Backups/athenaeum"
log="$HOME/.local/logs/palladium/pall-open-book-log.csv"
all_attr=(type title subtitle author volume edition first_pub year publisher country language trans_p orig_lang transor filename)



function dup-check {
    if [[ "$(xsv search -s "$1" "^$2" "$ix" | xsv select "$1" | sed 1d | wc -l)" -gt 1 ]]
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
    xsv search -s "$dup_field" "^$dup_term" "$ix" | xsv select "$view_fields" | sed 1d | fzf | ifne xsv select "$alt_field_order"
}

function best-algo {
    # best methods to deal with duplicates
    best=(author author volume volume,subtitle language language,trans_p edition edition,year publisher publisher country country,language transor transor,language filename filename)
    attr_diff=()
    for j in $(xsv headers -j "$ix")
    do
	if [[ "$(xsv search -s "$1" "^$2" "$ix" | xsv select "$j" | sed 1d | sort | uniq | wc -l)" -gt 1 ]]
	then
	    attr_diff+=("$j")
	fi
    done
    [[ -z "$attr_diff" ]] && return 1
}

function choose-book {
    [[ -z "$sld_ttl" ]] && sld_ttl="$(xsv select title "$ix" | tr -d '"' | sed 1d | sort | uniq | fzf)"
    [[ -z "$sld_ttl" ]] && return 1
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
	[[ -z "$dup_out" ]] && return 1
	sld_fnm="$loc/$(xsv search -s title "^$sld_ttl" "$ix" | xsv search -s "$chosen_best" "^$dup_out" | xsv select filename | sed -n 2p)"
    else
	sld_fnm="$loc/$(xsv search -s title "^$sld_ttl" "$ix" | xsv select filename | sed -n 2p)"
    fi
}


function backup-index {
    cmp -s "$ix" "$bkp/$(eza -1f "$bkp" | tail -n 1)" || {
	show-stats
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
	"Year") sterm=first_pub ;;
	*) echolor red ":: No search parameter chosen."
	   return
	   ;;
    esac
    filterer="$(xsv select "$sterm" "$ix" | sed 1d | sed '/""/d' | tr -d '"' | sort | uniq | fzf)"
    [[ -z "$filterer" ]] && return 1
    sld_ttl="$(xsv select title,"$sterm" "$ix" | xsv search -s "$sterm" "^$filterer" | xsv select title | tr -d '"' | sed 1d | sort | uniq | fzf)"
    [[ -z "$sld_ttl" ]] && return 1
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
	return 1
    }
    [[ -e "$1" ]] || {
	echolor red ":: This file does not exist."
	return 1
    }
    [[ -e "$loc/$1" ]] && {
	echolor red ":: This file already exists in index."
	return 1
    }
    nix="/tmp/ath-new-entry-$(date-string).csv"
    nixf="$nix.form"
    touch "$nix" "$nixf"
    IFS=$'\n'
    sed -n 1p "$ix" >> "$nix"
    for j in $(xsv headers -j "$ix" | sed '/^filename$/d')
    do
	echo -e "$j ––– \t" >> "$nixf"
    done
    emacsclient -nw -a emacs "$nixf"
    for j in $(cat "$nixf")
    do
	value="$(echo "$j" | awk -F '–––' '{print $NF}' | sed 's/\t//g;s/^ *//g;s/ *$//g' | sed "s/'/’/g")"
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
    [[ -z "$sld_fnm" ]] && return 1
    zathura "$sld_fnm" 2>/dev/null &
    echo "$(date-string ymdhm),\"$sld_ttl\",$sld_fnm" >> "$HOME/.local/logs/palladium/pall-open-book-log.csv"
}

function show-info {
    choose-book || return 1
    base_fnm="$(basename -- "$sld_fnm")"
    echolor blue "$(stat "$sld_fnm"; echo -n " MSize: ")" 1
    echolor purple "$(du -h "$sld_fnm" | awk '{print $1}')"
    echolor yellow '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
    echolor white "$(xsv search -s filename "^$base_fnm" "$ix" | xsv flatten)"
}

[[ -z "$ix" ]] && {
    echolor red ":: Index variable not set!"
    exit
}

function show-stats {
    total="$(xsv count "$ix")"
    echolor yellow ":: Found ““$total”” records."
}

function open-history {
    sld_fnm="$(tac "$log" | grep $(date-string ymd) | xsv select -n 3 | awk -F '/' '{print $NF}' | sort | uniq | fzf)"
    [[ -z "$sld_fnm" ]] && return 1
    zathura "$loc/$sld_fnm" 2>/dev/null &
}

backup-index
dup-check-in-index
case "$1" in
    "by") search-by ;;
    "link") symlinker ;;
    "add") add-entry "$2" ;;
    "info") show-info ;;
    "stats") show-stats ;;
    "hist") open-history ;;
    "") open-book ;;
    *) echolor red ":: Unknown command." ;;
esac
