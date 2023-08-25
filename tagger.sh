#!/bin/bash

function init {
    [[ -e .tags ]] && echo ":: Tagfile already exists." || ls -1p | grep -v '/' | sort -V | sed 's/$/|/g' > .tags
}

function get-tags {
    wf="$(basename "$1")"
    read -a wftags <<<"$(grep "^$wf" .tags | awk -F '|' '{print $NF}')"

}

function get-files {
    listoffiles="$(grep -E "$1" .tags | awk -F '|' '{print $1}')"
    [ -z "$listoffiles" ] && return
    echo -e "\033[33m:: Found $(echo "$listoffiles" | wc -l) matching files\033[0m"
    while true
    do
	[ -z "$listoffiles" ] && break
	export current_file="$(echo -e "$listoffiles" | sed 1q)"
	ftc="$(file -b "$current_file" | awk '{print $1}')"
	[ "$ftc" = "ISO" ] && mpv --no-terminal --no-resume-playback --loop=inf "$current_file"
	[ "$ftc" != "ISO" ] && xdg-open "$current_file"
	echo -e "--------------------------------"
	echo -e ":: Opened file \033[32m$current_file\033[0m"
	listoffiles="$(echo -e "$listoffiles" | tail -n +2)"
	read -r -p ":: Press <return> to continue."
done    
}

function new-tag {
    get-tags "$1"
    echo -e ":: Existing tags for $wf are: \033[32m${wftags[@]}\033[0m"
    read -r -p ":: Add new tags: " newtags
    wftags=("${wftags[@]}" $(echo $newtags))
    fullline="$(grep "^$wf" .tags)"
    newfullline="$(echo "$wf|${wftags[@]}")"
    sed -i "s/$fullline/$newfullline/g" .tags
}

function erase {
    get-tags "$1"
    read -r -p ":: Erase tags for $wf? [yN] " erase_p
    fullline="$(grep "^$wf" .tags)"
    newfullline="$(echo "$wf|")"
    [[ "$erase_p" = "y" ]] && sed -i "s/$fullline/$newfullline/g" .tags || echo ":: Nothing done."
}

case "$1" in
    "init") init
	    ;;
    "get") get-tags "$2"
	   echo -e ":: Tags for $wf are: \033[32m${wftags[@]}\033[0m"
	   ;;
    "see") get-files "$2"
	   ;;
    "new") new-tag "$2"
	   echo -e ":: Tags for $wf are: \033[32m"$(grep "^$wf" .tags | awk -F '|' '{print $NF}')"\033[0m"
	   ;;
    "erase") erase "$2"
	     ;;
    *) echo ":: Incorrect command."
       ;;
esac

	  
	  
