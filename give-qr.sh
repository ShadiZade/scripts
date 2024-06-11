#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh
case "$quote_p" in
    "y") url="$(rofi -dmenu -format q -p 'Enter text')" ;;
    *)   url="$(rofi -dmenu -p 'Enter URL')" ;;
esac
[[ -z "$url" ]] && exit
filen="$(random-string).jpg"
qrencode -o /tmp/"$filen" "$url"
sxiv /tmp/"$filen"
