#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh 

current_file="$usdd/zas-current-study"
reserve_file="$usdd/zas-reserve-study"
use_program="zathura"

function add-study {
    [[ "$current_or_reserve" -eq 1 ]] && {
	storage_file="$reserve_file"
	destination="reserve"
    } || {
	storage_file="$current_file"
	destination="current"
    }
    [[ -e "$1" ]] || {
	echolor red ":: Nothing found."
	exit
    }
    echo "$(realpath "$1")" >> $storage_file
    
    echolor purple ":: ““$(basename "$1")”” added to ““$destination””"
}

function delete-study {
    [[ "$current_or_reserve" -eq 1 ]] \
	&& storage_file="$reserve_file" \
		       || storage_file="$current_file"
    removethis="$(cat $storage_file | fzf --prompt="Select file to REMOVE: ")"
    [ -z "$removethis" ] && echolor red ":: Nothing chosen." && exit
    sed -i "s|$removethis||g;/^$/d" $storage_file
    echolor purple ":: ““$(echo $removethis | awk -F '/' '{print $NF}')”” was removed."
}

function open-study {
    [[ "$current_or_reserve" -eq 1 ]] \
	&& storage_file="$reserve_file" \
		       || storage_file="$current_file"
    openthis="$(cat $storage_file | fzf --prompt="Select file to OPEN: ")"
    [ -z "$openthis" ] && echolor red ":: Nothing chosen." && exit
    echolor purple ":: Opened ““$(echo $openthis | awk -F '/' '{print $NF}')”” in ““$use_program””"
    echo -n $openthis | xclip -selection clipboard
    "$use_program" "$openthis" 2>/dev/null
}


function move-to-reserve {
    stashthis="$(cat $current_file | fzf --prompt="Select file to MOVE TO RESERVE: ")"
    [ -z "$stashthis" ] && echolor red ":: Nothing chosen." && exit
    sed -i "s|$stashthis||g;/^$/d" "$current_file"
    echo "$stashthis" >> "$reserve_file"
    echolor purple ":: ““$(echo $stashthis | awk -F '/' '{print $NF}')”” was moved to reserve."
}

function call-from-reserve {
    callthis="$(cat $reserve_file | fzf --prompt="Select file to MOVE TO CURRENT: ")"
    [ -z "$callthis" ] && echolor red ":: Nothing chosen." && exit
    sed -i "s|$callthis||g;/^$/d" "$reserve_file"
    echo "$callthis" >> "$current_file"
    echolor purple ":: ““$(echo $callthis | awk -F '/' '{print $NF}')”” was moved to current."
}

function view-study {
    i=1
    IFS=$'\n'
    for j in $(cat $reserve_file)
    do
	[[ "$i" -eq 1 ]] && echolor white '-------- RESERVE --------'
	print-name "$j" green
	((i++))
    done
    i=1
    for j in $(cat $current_file)
    do
	[[ "$i" -eq 1 ]] && echolor white '-------- CURRENT --------'
	print-name "$j" purple
	((i++))
    done
}

function print-name {
	full_name="$(realpath "$1" | sed "s|$HOME|~|g")"
	path_string="$(dirname "$1" | sed "s|$HOME|~|g")"
	max_length=$(($(tput cols) - 8))
	replace_which=3
    function replacer {
	replace_this="$(echo -n "$path_string" | xsv select -d '/' $replace_which)"
	path_string="$(echo -n "$path_string" | sed "s|$replace_this|...|")"
	full_name="$(echo -n "$path_string")/$(basename "$1")"
    }
    while [[ "$(echo -n $full_name | wc -c)" -gt "$max_length" ]]
    do
	replacer "$1"
	((replace_which++))
    done
    case $2 in
	purple) color=35 ;;
	green) color=32 ;;
    esac	
    path_string=$(echo -n "$path_string" | sed "s|\.\.\./\.\.\./\.\.\./|.../|g;s|\.\.\.|\\\\033[30m...\\\\033[${color}m|g")
    echolor "$2" "““$i””\t"$path_string"/““$(basename "$1")””"
}

current_or_reserve=0
while getopts 'movra:d' OPTION; do
    case "$OPTION" in
	"o") use_program="okular"; open-study ;;
	"r") current_or_reserve=1 ;;
	"v") view-study ;;
	"d") delete-study ;;
	"a") add-study "$OPTARG" ;;
	"m") case "$(echo -e "To reserve\nTo current" | fzf --prompt="Choose action: ")" in
		 "To current") call-from-reserve ;;
		 "To reserve") move-to-reserve ;;
		 *) echolor red ":: No option chosen"
		    exit ;;
	     esac
	     ;;
	*) echo incorrect input; exit ;;
	esac
done
(( $OPTIND == 1 )) && open-study

# TODO add "this book already exists" warning
# TODO add "done" category
