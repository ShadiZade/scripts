#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh

function detect-language {
    orig_name="$1"
    detected_lang=xx
    echo "$orig_name" \
	| grep -q "[ابتثجحخدذرزسشصضطظعغفقكلمنهويأءؤ]" \
	&& detected_lang=ar
    echo "$orig_name" \
	| grep -qi "[йцукенгшщзхъфывапролджэячсмитьбю]"  \
	&& detected_lang=ru
    echo "$orig_name" \
	| grep -qP "\p{Script=Han}"  \
	&& detected_lang=zh
    translate-kebab "$orig_name"
}

function translate-kebab {
    orig_name="$1"
    [ "$detected_lang" = "xx" ] \
	&& name_after_trans="$orig_name"  \
	&& return
    ext_alone="$(echo $orig_name | awk -F '.' '{print $NF}')"
    find-yt-url
    name_alone="$(echo $orig_name | sed "s/\.$ext_alone//")"
    [ -z "$yt_url" ] \
	|| name_alone="$(echo "$name_alone" | sed "s/$yt_url//")"
    name_translated="$(trans -b "$detected_lang":en "$name_alone")"
    [ -z "$yt_url" ] \
	|| yt_url="$(echo "-[$yt_url]")"
    name_final="$(echo $name_translated$yt_url.$ext_alone)"
    name_final="$(echo $name_final | sed 's|/|-|g')"
    case "$detected_lang" in
	"ar") detected_lang="Arabic" ;;
	"ru") detected_lang="Russian" ;;
	"zh") detected_lang="Chinese" ;;
    esac
    echo "$orig_name" \
	| grep -q "\." \
	|| name_final="$name_translated"
    echolor blue-aquamarine ":: $detected_lang name is ““$orig_name””"
    echolor blue-orange     ":: English name is ““$name_final””"
    echolor green ":: Perform the move? (Y/n/d) " 1
    read -r proceed
    proceed=${proceed:-y}
    case "$proceed" in
	"n") echolor red ":: Move not performed."
	     exit ;;
	"d") echolor orange ":: Enter alternative translation: " 1
	     read -r name_translated
	     name_final="$(echo $name_translated$yt_url.$ext_alone)"
	     echo "$orig_name" \
		 | grep -q "\." \
		 || name_final="$name_translated"
	     mv -ni -- "$orig_name" "$name_final" ;;
	  *) mv -ni -- "$orig_name" "$name_final" ;;	
    esac
    name_after_trans="$name_final"
}

function english-kebab {
    orig_name="$name_after_trans"
    echo $orig_name \
	| grep -q "/" \
	&& echo ":: This operation can only be performed inside the directory." \
	&& exit 1
    ext_alone="$(echo $orig_name | awk -F '.' '{print $NF}')"
    find-yt-url
    name_alone="$(echo $orig_name | sed "s/\.$ext_alone//")"
    ext_alone="$(echo "$ext_alone" | sed 's/jpeg/jpg/;s/jpg_large/jpg/;s/JPG/jpg/;s/PNG/png/;s/JPEG/jpg/')"
    [ -z "$yt_url" ] \
	|| name_alone="$(echo "$name_alone" | sed "s/$yt_url//")"
    name_kebab="$(~/Repositories/scripts/kebabization.sh "$name_alone"; cat "$usdd/kebab")"
    [ -z "$yt_url" ] \
	|| yt_url="$(echo "-[$yt_url]")"
    name_final="$(echo $name_kebab$yt_url.$ext_alone)"
    [ "$orig_name" == "$name_final" ] \
	&& echolor ashy ":: Filename is already kebab-compliant!" \
	&& exit 1
    [ "$orig_name" == "$name_kebab" ] \
	&& echolor ashy ":: Filename is already kebab-compliant!" \
	&& exit 1
    [ "$(stat -c %F -- "$orig_name")" = "directory" ] \
	&& name_final="$name_kebab"
    echo "$orig_name" \
	| grep -q "\." \
	|| name_final="$name_kebab"
    echolor blue-white  ":: old name is ““$orig_name””"
    echolor blue-yellow ":: new name is ““$name_final””"
    echolor green ":: Perform the move? (Y/n/d) " 1
    read -r proceed
    proceed=${proceed:-y}
     case "$proceed" in
	"n") echolor red ":: Move not performed."
	     exit ;;
	"d") echolor yellow  ":: Enter alternative name: " 1
	     read -r name_kebab
	     name_final="$(echo $name_kebab$yt_url.$ext_alone)"
	     echo "$orig_name" \
		 | grep -q "\." \
		 || name_final="$name_kebab"
	     mv -ni -- "$orig_name" "$name_final" ;;
	  *) mv -ni -- "$orig_name" "$name_final" ;;	
    esac
}

function find-yt-url {
    yt_url_p='n'
    echo "$orig_name" \
	| grep -q "\]\." \
	&& yt_url_p='y'
    [ "$yt_url_p" != 'y' ] \
	&& return
    yt_url="$(echo "$orig_name" | awk -F '[' '{print $NF}' | awk -F ']' '{print $1}')"	
}

function detect-file {
    [[ -e "$1" ]] || {
	echolor red ":: File ““$1”” does not exist!"
	exit 1
    }
}

detect-file "$1"
detect-language "$1"
english-kebab "$1"
