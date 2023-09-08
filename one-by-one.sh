#!/bin/bash
function tagger {
    ~/Repositories/scripts/tagger.sh "$1" "$2"
}

function rename-lof {
    echo -e ":: This will be number \033[31m$ordernum\033[0m."
    echo -e ":: This file is \033[31m$current_file\033[0m"
    read -r -p ":: Enter desired tags: " ordertag
    ext="${current_file##*.}"
    mv -v "$current_file" "$ordernum-$ordertag.$ext"
    export ordernum=$((ordernum+1))
}

function mark {
    [ -e .mark ] || touch .mark
    grep -q "^$current_file$" .mark && echo -e "\033[31m:: This file is already marked.\033[0m" && return
    read -r -p ":: Mark file? (y/N) " markthis
    [ "$markthis" = "y" ] && echo "$current_file" >> .mark && echo -e "\033[33m:: File marked.\033[0m"
}

[[ "$1" = "rename" ]] && read -r -p ":: Enter starting number: " ordernum
listoffiles="$(ls -1p | grep -v '/' | sort -V)"
echo -e "\033[33m:: $(echo "$listoffiles" | wc -l) files detected\033[0m"
i=1
[ -z "$1" ] && echo ":: No command chosen" && exit
[ -z "$2" ] || i="$2"
listoffiles="$(echo -e "$listoffiles" | tail -n +"$i")"
while true
do
    export current_file="$(echo -e "$listoffiles" | sed 1q)"
    ftc="$(file -b "$current_file" | awk '{print $1}')"
    [ "$ftc" = "ISO" ] && mpv --no-terminal --no-resume-playback --loop=inf "$current_file"
    [ "$ftc" != "ISO" ] && xdg-open "$current_file"
    echo -e "--------------------------------"
    echo -e ":: Opened file \033[32m$i\033[0m"
    case "$1" in
	"rename") rename-lof
		  ;;
	"view") echo -e ":: This file is \033[31m$current_file\033[0m"
		;;
	"mark") echo -e ":: This file is \033[31m$current_file\033[0m"
		mark
		;;
     	*) tagger "$1" "$current_file"
	   ;;
    esac
    listoffiles="$(echo -e "$listoffiles" | tail -n +2)"
    [ -z "$listoffiles" ] && break
    i=$((i+1))
    read -r -p ":: Press <return> to continue."
done

