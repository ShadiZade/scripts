#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh
loc="$HOME/Athenaeum"
ix="$usdd/athenaeum-index.csv"
bkp="$HOME/Misc/Backups/athenaeum"
log="$HOME/.local/logs/palladium/pall-open-book-log.csv"
all_attr=(type title subtitle author series volume edition first_pub year publisher country language trans_p orig_lang transor filename id)



function dup-check {
    if [[ "$(xsv search -s "$1" "^$2" "$3" | xsv select "$1" | sed 1d | wc -l)" -gt 1 ]]
    then
	return 0
    else
	return 1
    fi
}

function dupper {
    # dupper index_file field_already_queried other_field_to_query term fields_to_display_comma_separated order_of_field
    # dupper "$ix" title volume XYZ volume,subtitle 1
    # e.g. can be run if two books titled XYZ are found (in order to choose by volume).
    # $5 is the order in which the chosen variable in $4 is located, so if "subtitle" is to be
    # used, $5 would be "2" in the previous example. This is reflected in $best.
    dup_file="$1"
    dup_field="$2"
    alt_field="$3"
    dup_term="$4"
    view_fields="$5"
    alt_field_order="$6"
    [[ -z "$view_fields" ]] && view_fields="$alt_field"
    [[ -z "$alt_field_order" ]] && alt_field_order=1
    dup_tmp="/tmp/pall-dupper-$(random-string).csv"
    xsv search -s "$dup_field" "^$dup_term$" "$dup_file" > "$dup_tmp"
}

function dup-filter {
    cat "$dup_tmp"                                \
	| xsv select "$view_fields"               \
	| sed 1d                                  \
	| sort -V                                 \
	| uniq                                    \
	| fzf                                     \
	| ifne xsv select "$alt_field_order"      
}

function redupper {
    [[ ! -e "$dup_tmp" ]] && return 1
    [[ "$(cat "$dup_tmp" | wc -l)" -eq 2 ]] && return 0
    best-algo "$alt_field" "$dup_out" "$dup_tmp"
    dupper "$dup_tmp" "$alt_field" "$chosen_best" "$dup_out" "$chosen_best_config" "$chosen_order_of_field"
    [[ "$(cat "$dup_tmp" | wc -l)" -eq 2 ]] && return 0
    dup_out=$(dup-filter)
    [[ -z "$dup_out" ]] && return 1
    redupper
}

function best-algo {
    # best methods to deal with duplicates
    best=(author author 1 volume series,volume,subtitle 2 language language,trans_p 1 edition edition,year 1 publisher publisher 1 country country,language 1 transor transor,language 1 filename filename 1)
    attr_diff=()
    for j in $(xsv headers -j "$ix")
    do
	if [[ "$(xsv search -s "$1" "^$2$" "$3" | xsv select "$j" | sed 1d | sort | uniq | sed '/^""$/d' | wc -l)" -gt 1 ]]
	then
	    attr_diff+=("$j")
	fi
    done
    [[ -z "$attr_diff" ]] && return 1
    i=-1
    for j in ${best[@]}
    do
	((i++))
	[[ $((i%3)) -eq 0 ]] && {
	    if $(echo "${attr_diff[@]}" | grep -q "$j")
	    then
		chosen_best=${best[$i]}
		chosen_best_config=${best[((i+1))]}
		chosen_order_of_field=${best[((i+2))]}
		break
	    fi
	    continue
	}
    done
}

function choose-book {
    [[ ! -z "$sld_fnm" ]] && return 0
    [[ -z "$sld_ttl" ]] && sld_ttl="$(xsv select title "$ix" | tr -d '"' | sed 1d | sort | uniq | fzf | sed 's/?/\\?/g')"
    [[ -z "$sld_ttl" ]] && return 1
    if $(dup-check title "$sld_ttl" "$ix")
    then
	best-algo title "$sld_ttl" "$ix"
	dupper "$ix" title "$chosen_best" "$sld_ttl" "$chosen_best_config" "$chosen_order_of_field"
	dup_out=$(dup-filter)
    	[[ -z "$dup_out" ]] && return 1
	redupper || return 1
	sld_fnm="$loc/$(xsv search -s title "^$sld_ttl$" "$ix" | xsv search -s "$chosen_best" "^$dup_out" | xsv select filename | sed -n 2p)"
    else
	sld_fnm="$loc/$(xsv search -s title "^$sld_ttl$" "$ix" | xsv select filename | sed -n 2p)"
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
    function search-by-default {
	filterer="$(xsv select "$1" "$ix" | sed 1d | sed '/""/d' | tr -d '"' | sort | uniq | fzf)"
	[[ -z "$filterer" ]] && return 1
	sld_ttl="$(xsv select title,"$1" "$ix" | xsv search -s "$1" "^$filterer$" | xsv select title | tr -d '"' | sed 1d | sort | uniq | fzf)"
	[[ -z "$sld_ttl" ]] && return 1
	export sld_ttl
	open-book
    }
    function search-by-series {
	filterer="$(xsv select series "$ix" | sed 1d | sed '/""/d' | tr -d '"' | sort | uniq | fzf)"
	[[ -z "$filterer" ]] && return 1
	dupper "$ix" series volume "$filterer" "series,volume,author,title,subtitle" 2
	dup_out="$(dup-filter)"
	[[ -z "$dup_out" ]] && return 1
	redupper || return 1
	sld_fnm="$loc/$(xsv search -s series "^$filterer$" "$ix" | xsv search -s volume "^$dup_out" | xsv select filename | sed -n 2p)"
	[[ -z "$sld_fnm" ]] && return 1
	export sld_fnm
	open-book
    }
    case "$(echo -e "Author\nCountry\nLanguage\nPublisher\nSeries\nType\nYear" | fzf)" in
	"Author") search-by-default author ;;
	"Country") search-by-default country ;;
	"Language") search-by-default language ;;
	"Publisher") search-by-default publisher ;;
	"Type") search-by-default type ;;
	"Year") search-by-default first_pub ;;
	"Series") search-by-series ;;
	*) echolor red ":: No search parameter chosen."
	   return
	   ;;
    esac
}

function dup-check-in-index {
    # check for duplicated lines
    cat "$ix" | sort | uniq -c | grep -qv "^      1" && {
	IFS=$'\n'
	for j in $(cat "$ix" | sort | uniq -c | grep -v "^      1" | xsv select 2)
	do
	    echolor red ":: Duplication detected in index file: ““$j””"
	done
	unset IFS
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
    for j in $(xsv headers -j "$ix" | sed '/^filename$/d;/^id$/d')
    do
	echo -e "$j ––– \t" >> "$nixf"
    done
    emacsclient -nw -a emacs "$nixf"
    sed -i '/^$/d' "$nixf"
    cat "$nixf" | grep -v '–––' && {
	echolor red ":: Input error!"
	return 1
    }
    for j in $(cat "$nixf")
    do
	value="$(echo "$j" | awk -F '–––' '{print $NF}' | sed 's/\t//g;s/^ *//g;s/ *$//g' | sed "s/'/’/g;s/,/‚/g;s/(/⟮/g;s/)/⟯/g")"
	echo "$value" | grep -q ',' && value="\"$value\""
	echo -n "$value," >> "$nix"
    done
    while true
    do
	identifier="$(random-string 8)"
	xsv select id "$ix" | grep -q "$identifier" || break
    done
    echo -n "$(basename "$1"),$identifier" >> "$nix"
    xsv flatten "$nix" | sed 's/,/⸴/g' | csvlens --no-headers
    [[ "$(xsv select title "$nix" | sed 1d)" = '""' ]] && {
	echolor red ":: Title can't be empty!"
	return 1
    }
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
    unset IFS
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
    echolor violet-orange ":: Found ““$total”” records."
}

function open-history {
    sld_fnm="$(tac "$log" | grep $(date-string ymd) | xsv select -n 3 | awk -F '/' '{print $NF}' | sort | uniq | fzf)"
    [[ -z "$sld_fnm" ]] && return 1
    zathura "$loc/$sld_fnm" 2>/dev/null &
}

function from-id {
    xsv -s id "$1" "$3" | ifne xsv select "$2" | sed 1d
}

function open-from-file {
    sld_fnm="$(tac "$usdd/pall-$1" | ifne awk -F '/' '{print $NF}' | sort | uniq | ifne fzf)"
    [[ -z "$sld_fnm" ]] && return 1
    zathura "$loc/$sld_fnm" 2>/dev/null &
}

function put-in {
    pc="$usdd/pall-current"
    pd="$usdd/pall-done"
    case "$(echo -e "To current\nTo done" | fzf)" in
	"To current")   choose-book || return 1
			[[ -z "$sld_fnm" ]] && return 1
			cat "$pc" | grep -q "^$sld_fnm$" && {
			    echolor red ":: Book ““$sld_ttl”” is already in ““current””"
			    return 1
			}
			echo "$sld_fnm" >> "$pc"
		       	echolor green ":: Book ““$sld_ttl”” added to ““current””"
			;;
	"To done")    choose-book || return 1
		      [[ -z "$sld_fnm" ]] && return 1
		      cat "$pc" | grep -q "^$sld_fnm$" \
			  && echolor yellow-violet ":: Book ““$sld_ttl”” found in ““current””, removing..."
		      sed -i "s|^$sld_fnm$||g;/^$/d" "$pc" || return 1
		      cat "$pd" | grep -q "^$sld_fnm$" && {
			  echolor red ":: Book ““$sld_ttl”” is already in ““done””"
			  return 1
		      }
		      echo "$sld_fnm" >> "$pd"
		      echolor green ":: Book ““$sld_ttl”” added to ““done””"
		      ;;
	*) return 1 ;;
    esac
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
    "curr") open-from-file current ;;
    "done") open-from-file done ;;
    "put") put-in ;;
    "") open-book ;;
    *) echolor red ":: Unknown command." ;;
esac
