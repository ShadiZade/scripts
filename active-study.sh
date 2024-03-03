#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh 

storage_file="$usdd/active-study"
use_program="zathura"

function add-study {
	filename_copied="$(ls -1 | grep "$1")"
	[ -z "$filename_copied" ] && echolor red ":: Nothing found." && exit
	echo "$(realpath "$filename_copied")" >> $storage_file
	echolor purple ":: ““$filename_copied”” added to active study."
}

function remove-study {
	removethis="$(cat $storage_file | fzf)"
	[ -z "$removethis" ] && echolor red ":: Nothing chosen." && exit
	sed -i "s|$removethis||g;/^$/d" $storage_file
	echolor purple ":: ““$(echo $removethis | awk -F '/' '{print $NF}')”” was removed."
}

function open-study {
	openthis="$(cat $storage_file | fzf)"
	[ -z "$openthis" ] && echolor red ":: Nothing chosen." && exit
	echolor purple ":: Opened ““$(echo $openthis | awk -F '/' '{print $NF}')”” in ““$use_program””"
	echo -n $openthis | xclip -selection clipboard
	"$use_program" "$openthis" 2>/dev/null
}

function view-study {
    i=1
    IFS=$'\n'
    for j in $(cat $storage_file)
    do
	echolor purple "““$i””\t$(dirname "$j")/““$(basename "$j")””"
	((i++))
    done
}


while getopts 'ozvra:' OPTION; do
    case "$OPTION" in
	"o") use_program="okular"; open-study ;;
	"v") view-study ;;
	"r") remove-study ;;
	"a") add-study "$OPTARG" ;;
	*) echo incorrect input; exit ;;
	esac
done
(( $OPTIND == 1 )) && open-study
