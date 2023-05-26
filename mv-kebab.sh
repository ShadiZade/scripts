#!/bin/bash

function detect-language {
    orig_name="$1"
    detected_lang=xx
    echo "$orig_name" | grep -q "[ابتثجحخدذرزسشصضطظعغفقكلمنهويأءؤ]" && detected_lang=ar
    echo "$orig_name" | grep -qi "[йцукенгшщзхъфывапролджэячсмитьбю]" && detected_lang=ru
    echo "$orig_name" | grep -qP "\p{Script=Han}" && detected_lang=zh
    # How chinese??????
    translate-kebab "$orig_name"
}

function translate-kebab {
    orig_name="$1"
    [ "$detected_lang" = "xx" ] && name_after_trans="$orig_name" && return
    ext_alone="$(echo $orig_name | awk -F '.' '{print $NF}')"
    find-yt-url
    name_alone="$(echo $orig_name | sed "s/\.$ext_alone//")"
    [ -z "$yt_url" ] ||	name_alone="$(echo "$name_alone" | sed "s/$yt_url//")"
    name_translated="$(trans -b "$detected_lang":en "$name_alone")"
    [ -z "$yt_url" ] || yt_url="$(echo "-[$yt_url]")"
    name_final="$(echo $name_translated$yt_url.$ext_alone)"
    case "$detected_lang" in
	"ar") detected_lang="Arabic" ;;
	"ru") detected_lang="Russian" ;;
	"zh") detected_lang="Chinese" ;;
    esac
    echo "$orig_name" | grep -q "\." || name_final="$name_translated"
    echo -e ":: $detected_lang name is \033[33m$orig_name\033[0m"
    echo -e ":: English name is \033[37m$name_final\033[0m"
    read -r -p ":: Perform the move? (Y/n/d) " proceed
    proceed=${proceed:-y}
    case "$proceed" in
	"n") echo ":: Move NOT performed."
	     exit ;;
	"d") read -r -p ":: Enter alternative translation: " name_translated
	     name_final="$(echo $name_translated$yt_url.$ext_alone)"
	     echo "$orig_name" | grep -q "\." || name_final="$name_translated"
	     mv -niv -- "$orig_name" "$name_final" ;;
	  *) mv -niv -- "$orig_name" "$name_final" ;;	
    esac
    name_after_trans="$name_final"
}

function english-kebab {
    orig_name="$name_after_trans"
    echo $orig_name | grep -q "/" && echo ":: This operation can only be performed inside the directory." && exit
    ext_alone="$(echo $orig_name | awk -F '.' '{print $NF}')"
    find-yt-url
    name_alone="$(echo $orig_name | sed "s/\.$ext_alone//")"
    ext_alone="$(echo "$ext_alone" | sed 's/jpeg/jpg/;s/jpg_large/jpg/;s/JPG/jpg/;s/PNG/png/;s/JPEG/jpg/')"
    [ -z "$yt_url" ] ||	name_alone="$(echo "$name_alone" | sed "s/$yt_url//")"
    name_kebab="$(~/Repositories/scripts/kebabization.sh "$name_alone"; cat ~/.kebab)"
    [ -z "$yt_url" ] || yt_url="$(echo "-[$yt_url]")"
    name_final="$(echo $name_kebab$yt_url.$ext_alone)"
    [ "$orig_name" == "$name_final" ] && echo ":: Filename is already kebab-compliant!" && exit
    [ "$orig_name" == "$name_kebab" ] && echo ":: Filename is already kebab-compliant!" && exit
    [ "$(stat -c %F -- "$orig_name")" = "directory" ] && name_final="$name_kebab"
    echo "$orig_name" | grep -q "\." || name_final="$name_kebab"
    echo -e ":: old name is \033[33m$orig_name\033[0m"
    echo -e ":: new name is \033[37m$name_final\033[0m"
    read -r -p ":: Perform the move? (Y/n/d) " proceed
    proceed=${proceed:-y}
     case "$proceed" in
	"n") echo ":: Move NOT performed."
	     exit ;;
	"d") read -r -p ":: Enter alternative name: " name_kebab
	     name_final="$(echo $name_kebab$yt_url.$ext_alone)"
	     echo "$orig_name" | grep -q "\." || name_final="$name_kebab"
	     mv -niv -- "$orig_name" "$name_final" ;;
	  *) mv -niv -- "$orig_name" "$name_final" ;;	
    esac
}

function find-yt-url {
    yt_url_p='n'
    echo "$orig_name" | grep -q "\]\." && yt_url_p='y'
    [ "$yt_url_p" != 'y' ] && return
    yt_url="$(echo "$orig_name" | awk -F '[' '{print $NF}' | awk -F ']' '{print $1}')"	
}

detect-language "$1"
english-kebab "$1"
