#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh 

current_file="$usdd/active-study"
reserve_file="$usdd/reserve-study"
use_program="zathura"

function add-study {
    [[ "$current_or_reserve" -eq 1 ]] && {
	storage_file="$reserve_file"
	destination="reserve"
    } || {
	storage_file="$current_file"
	destination="current"
    }
    filename_copied="$(ls -1 | grep "$1")"
    [ -z "$filename_copied" ] && echolor red ":: Nothing found." && exit
    echo "$(realpath "$filename_copied")" >> $storage_file
    
    echolor purple ":: ““$filename_copied”” added to ““$destination””"
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
	echolor green "““$i””\t$(dirname "$j")/““$(basename "$j")””"
	((i++))
    done
    i=1
    for j in $(cat $current_file)
    do
	[[ "$i" -eq 1 ]] && echolor white '-------- CURRENT --------'
	echolor purple "““$i””\t$(dirname "$j")/““$(basename "$j")””"
	((i++))
    done
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
