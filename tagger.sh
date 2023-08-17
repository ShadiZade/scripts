#!/bin/bash

function init {
    [[ -e .tags ]] && echo ":: Tagfile already exists." || ls -1p | grep -v '/' | sort -V | sed 's/$/|/g' > .tags
}

function get-tags {
    wf="$(basename "$1")"
    read -a wftags <<<"$(grep "$wf" .tags | awk -F '|' '{print $NF}')"

}

function get-files {
    grep "$1" .tags | awk -F '|' '{print $1}'
}

function new-tag {
    get-tags "$1"
    read -rp ":: Add new tags: " newtags
    wftags=("${wftags[@]}" $(echo $newtags))
    fullline="$(grep "$wf" .tags)"
    newfullline="$(echo "$wf|${wftags[@]}")"
    sed -i "s/$fullline/$newfullline/g" .tags
}

function erase {
    get-tags "$1"
    read -rp ":: Erase tags for $wf? [yN] " erase_p
    fullline="$(grep "$wf" .tags)"
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
	   echo -e ":: Tags for $wf are: \033[32m${wftags[@]}\033[0m"
	   ;;
    "erase") erase "$2"
	     ;;
    *) echo ":: Incorrect command."
       ;;
esac

	  
	  
