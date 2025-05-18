#!/bin/bash
source ~/Repositories/scripts/essential-functions
[[ -z "$@" ]] && {
    url="$(rofi -dmenu -p 'Enter URL')"
} || {
    url="$@"
}
[[ -z "$url" ]] && exit
filen="$(random-string).png"
zint --scale 5 --barcode qrcode --data "$url" --output /tmp/"$filen" 2>/dev/null
sxiv /tmp/"$filen"
