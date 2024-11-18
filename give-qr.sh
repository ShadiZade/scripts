#!/bin/bash
source ~/Repositories/scripts/essential-functions
url="$(rofi -dmenu -p 'Enter URL')"
[[ -z "$url" ]] && exit
filen="$(random-string).jpg"
qrencode -o /tmp/"$filen" "$url"
sxiv /tmp/"$filen"
