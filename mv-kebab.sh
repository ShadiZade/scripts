#!/bin/bash


function arabic-kebab {
    orig_name="$1"
    echo "$orig_name" | grep -q "[ابتثجحخدذرزسشصضطظعغفقكلمنهويأءؤ]" || name_after_arabic="$orig_name"
    echo "$orig_name" | grep -q "[ابتثجحخدذرزسشصضطظعغفقكلمنهويأءؤ]" || return
    ext_alone="$(echo $orig_name | awk -F '.' '{print $NF}')"
    find-yt-url
    name_alone="$(echo $orig_name | sed "s/\.$ext_alone//")"
    [ -z "$yt_url" ] ||	name_alone="$(echo "$name_alone" | sed "s/$yt_url//")"
    name_translated="$(trans -b ar:en "$name_alone")"
    [ -z "$yt_url" ] || yt_url="$(echo "-[$yt_url]")"
    name_final="$(echo $name_translated$yt_url.$ext_alone)"
    echo "$orig_name" | grep -q "\." || name_final="$name_translated"
    echo -e ":: Arabic name is \033[33m$orig_name\033[0m"
    echo -e ":: English name is \033[37m$name_final\033[0m"
    read -r -p ":: Perform the move? (Y/n/d) " proceed
    proceed=${proceed:-y}
    case "$proceed" in
	"n") echo ":: Move NOT performed."
	     exit ;;
	"d") read -r -p ":: Enter alternative translation: " name_translated
	     name_final="$(echo $name_translated$yt_url.$ext_alone)"
	     mv -iv -- "$orig_name" "$name_final" ;;
	  *) mv -iv -- "$orig_name" "$name_final" ;;	
    esac
    name_after_arabic="$name_final"
}

function english-kebab {
    orig_name="$name_after_arabic"
    echo $orig_name | grep -q "/" && echo ":: This operation can only be performed inside the directory." && exit
    ext_alone="$(echo $orig_name | awk -F '.' '{print $NF}')"
    find-yt-url
    name_alone="$(echo $orig_name | sed "s/\.$ext_alone//")"
    ext_alone="$(echo "$ext_alone" | sed 's/jpeg/jpg/')"
    [ -z "$yt_url" ] ||	name_alone="$(echo "$name_alone" | sed "s/$yt_url//")"
    name_kebab="$(~/Repositories/scripts/kebabization.sh "$name_alone"; cat ~/.kebab)"
    [ -z "$yt_url" ] || yt_url="$(echo "-[$yt_url]")"
    name_final="$(echo $name_kebab$yt_url.$ext_alone)"
    [ "$orig_name" == "$name_final" ] && echo ":: Filename is already kebab-compliant!" && exit
    [ "$orig_name" == "$name_kebab" ] && echo ":: Filename is already kebab-compliant!" && exit
    [ "$(stat -c %F "$orig_name")" = "directory" ] && name_final="$name_kebab"
    echo "$orig_name" | grep -q "\." || name_final="$name_kebab"
    echo -e ":: old name is \033[33m$orig_name\033[0m"
    echo -e ":: new name is \033[37m$name_final\033[0m"
    read -r -p ":: Perform the move? (Y/n) " proceed
    proceed=${proceed:-y}
    [ "$proceed" != "y" ] && echo ":: Move NOT performed." && exit
    mv -iv -- "$orig_name" "$name_final"
}

function find-yt-url {
    yt_url_p='n'
    echo "$orig_name" | grep -q "\]\." && yt_url_p='y'
    [ "$yt_url_p" != 'y' ] && return
    yt_url="$(echo "$orig_name" | awk -F '[' '{print $NF}' | awk -F ']' '{print $1}')"	
}

arabic-kebab "$1"
english-kebab "$1"
