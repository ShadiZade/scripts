#!/bin/bash
source /home/oak/Repositories/scripts/essential-functions.sh

fontname="$1"
echo "$fontname" | grep -Eq "ttf|otf" || {
    echolor red ":: Not a font file!" 
    exit
}
sudo mv -v -- "$1" "/usr/share/fonts/TTF" \
    || exit
fc-cache -f \
    && echolor yellow ":: Font cache updated!" \
	|| echolor red ":: WARNING: Font cache failed!"

fc-list | grep "$(echo "$fontname" | awk -F '.' '{print $1}')"

# TODO replace script
