#!/bin/bash

fontname="$1"

echo "$fontname" | grep -q "ttf" || echo "Not a font file!" 
echo "$fontname" | grep -q "ttf" || exit

sudo mv -v -- "$1" "/usr/share/fonts/TTF" && echo -e "\033[31m:: Font file moved to fonts directory\033[0m" || exit
fc-cache -f && echo -e "\033[31m:: Font cache updated\033[0m" || echo -e "\033[33m:: WARNING: Font cache failed!\033[0m"
fc-list | grep $(echo "$fontname" | awk -F '.' '{print $1}')
