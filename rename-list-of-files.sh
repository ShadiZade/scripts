#!/bin/bash
function rename-lof {
    echo -e ":: This will be number \033[31m$ordernum\033[0m."
    echo -e ":: This file is \033[31m$current_file\033[0m"
    read -r -p ":: Enter desired tags: " ordertag
    ext="${current_file##*.}"
    mv -v "$current_file" "$ordernum-$ordertag.$ext"
    export ordernum=$((ordernum+1))
}

	
read -r -p ":: Enter starting number: " ordernum
listoffiles="$(ls -1p | grep -v '/' | sort -V)"
echo -e "\033[33m:: $(echo "$listoffiles" | wc -l) files detected\033[0m"
i=1
[ -z "$1" ] || i="$1"
listoffiles="$(echo -e "$listoffiles" | tail -n +"$i")"
while true
do
    export current_file="$(echo -e "$listoffiles" | sed 1q)"
    ftc="$(file -b "$current_file" | awk '{print $1}')"
    [ "$ftc" = "ISO" ] && mpv --no-terminal --loop=inf "$current_file"
    [ "$ftc" != "ISO" ] && xdg-open "$current_file"
    echo -e "--------------------------------"
    echo -e ":: Opened file \033[32m$i\033[0m"
    rename-lof
    listoffiles="$(echo -e "$listoffiles" | tail -n +2)"
    [ -z "$listoffiles" ] && break
    i=$((i+1))
    read -r -p ":: Press <return> to continue."
done

