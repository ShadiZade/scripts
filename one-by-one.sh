#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh

function tagger {
    ~/Repositories/scripts/tagger.sh "$1" "$2"
}

function rename-lof {
    echo -e ":: This will be number \033[31m$ordernum\033[0m."
    echo -e ":: This file is \033[31m$j\033[0m"
    read -r -p ":: Enter desired tags: " ordertag
    ext="${j##*.}"
    mv -nv "$j" "$ordernum-$ordertag.$ext"
    export ordernum=$((ordernum+1))
}

function mark {
    [[ -e .mark ]] || touch .mark
    grep -q "^$j$" .mark && echo -e "\033[31m:: This file is already marked.\033[0m" && return
    read -r -p ":: Mark file? (y/N) " markthis
    [[ "$markthis" = "y" ]] && echo "$j" >> .mark && echo -e "\033[33m:: File marked.\033[0m"
}



[[ -z "$1" ]] \
    && echo ":: No command chosen" && exit
[[ -z "$2" ]] \
    && i=1  \
	|| i="$2"

listoffiles=($(eza -1f . | sort -V | tail -n +"$i"))
[[ "$1" = "rename" ]] \
    && listoffiles=($(eza -1f . | sort -V | tail -n +"$i" | shuffle -)) \
    && read -r -p ":: Enter starting number: " ordernum
echo -e "\033[33m:: ${#listoffiles[@]} files detected\033[0m"

for j in "${listoffiles[@]}"
do
    ftc="$(file -b "$j" | awk '{print $1}')"
    [[ "$ftc" = "ISO" ]] \
	&& mpv --osd-fractions --no-terminal --no-resume-playback --loop=inf "$j" \
	    || xdg-open "$j"
    echo -e "--------------------------------"
    echo -e ":: Opened file \033[32m$i\033[0m"
    case "$1" in
	"rename")
	    rename-lof
	    ;;
	"view")
	    echo -e ":: This file is \033[31m$j\033[0m"
	    ;;
	"mark")
	    echo -e ":: This file is \033[31m$j\033[0m"
	    mark
	    ;;
     	*)
	    tagger "$1" "$j"
	    ;;
    esac
    ((i++))
    read -r -p ":: Press <return> to continue."
done

