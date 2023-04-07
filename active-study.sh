#!/bin/bash

add-study () {
	filename_copied="$(ls -1 | grep "$1")"
	[ -z "$filename_copied" ] && echo "nothing found." && exit
	path_copied="$(echo $(pwd)/$filename_copied)"
	echo $path_copied >> ~/.active-study	
	exit
}

remove-study () {
	removethis="$(cat ~/.active-study | fzf)"
	[ -z "$removethis" ] && echo "nothing chosen." && exit
	sed -i "s|$removethis||g;/^$/d" ~/.active-study
	echo $(echo $removethis | awk -F '/' '{print $NF}') was removed.
	exit
}

open-study () {
	openthis="$(cat ~/.active-study | fzf)"
	[ -z "$openthis" ] && echo "nothing chosen." && exit
	zathura "$openthis" & exit
}

view-study () {
	cat ~/.active-study | awk -F '/' '{print $NF}'
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
