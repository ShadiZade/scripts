#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh 

storage_file="$usdd/active-study"

add-study () {
	filename_copied="$(ls -1 | grep "$1")"
	[ -z "$filename_copied" ] && echolor red ":: Nothing found." && exit
	echo "$(realpath "$filename_copied")" >> $storage_file
	echolor yellow ":: ““$filename_copied”” added to active study."
}

remove-study () {
	removethis="$(cat $storage_file | fzf)"
	[ -z "$removethis" ] && echolor red ":: Nothing chosen." && exit
	sed -i "s|$removethis||g;/^$/d" $storage_file
	echolor yellow ":: ““$(echo $removethis | awk -F '/' '{print $NF}')”” was removed."
}

open-study () {
	openthis="$(cat $storage_file | fzf)"
	[ -z "$openthis" ] && echolor red ":: Nothing chosen." && exit
	echolor yellow ":: Opened ““$(echo $openthis | awk -F '/' '{print $NF}')””"
	echo -n $openthis | xclip -selection clipboard
	zathura "$openthis"
}

view-study () {
    i=1
    IFS=$'\n'
    for j in $(cat $storage_file)
    do
	echolor purple "““$i””\t$(dirname "$j")/““$(basename "$j")””"
	((i++))
    done
}

while getopts 'vra:' OPTION; do
    case "$OPTION" in 
	"v") view-study ;;
	"r") remove-study ;;
	"a") add-study "$OPTARG" ;;
	*) echo incorrect input; exit ;;
	esac
done
(( $OPTIND == 1 )) && open-study
