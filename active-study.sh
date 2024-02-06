#!/bin/bash

storage_file="$HOME/Misc/active-study"

add-study () {
	filename_copied="$(ls -1 | grep "$1")"
	[ -z "$filename_copied" ] && echo "nothing found." && exit
	echo "$(realpath "$filename_copied")" >> $storage_file
	exit
}

remove-study () {
	removethis="$(cat $storage_file | fzf)"
	[ -z "$removethis" ] && echo "nothing chosen." && exit
	sed -i "s|$removethis||g;/^$/d" $storage_file
	echo $(echo $removethis | awk -F '/' '{print $NF}') was removed.
	exit
}

open-study () {
	openthis="$(cat $storage_file | fzf)"
	[ -z "$openthis" ] && echo "nothing chosen." && exit
	zathura "$openthis" & exit
}

view-study () {
	cat $storage_file | awk -F '/' '{print $NF}'
	exit
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
