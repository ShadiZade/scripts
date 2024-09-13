#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh
# fuck you, WebP. I can't believe they killed JPEG XL for your sake.

while getopts 'i:o:' OPTION; do
    case "$OPTION" in
	"i") bf="$OPTARG" ;;
	"o") ef="$OPTARG" ;;
	*) echo incorrect input; exit ;;
	esac
done

bf="${bf:-webp}"
ef="${ef:-png}"

for j in $(fd -d 1 "$bf$" "$(pwd)")
do
    [[ ! -e "$j" ]] && {
	echolor red ":: File ““$j”” does not seem to exist."
	exit
    }
    magick "$j" "${j/.$bf/}.$ef" || {
	echolor red ":: Failed to convert ““$j””"
	break
    }
    echolor green-aquamarine ":: Converted ““$j”” to ““$ef””"
    rm -f "$j"
done
