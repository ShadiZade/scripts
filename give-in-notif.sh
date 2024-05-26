#!/bin/zsh
source ~/Repositories/scripts/essential-functions.sh

your_options="Hijri Calendar\nSystem Info\nWorld Clock"
choice=$(echo -e "$your_options" | rofi -i -dmenu -p "Choose thingy")
case $choice in
    "Hijri Calendar") ~/Repositories/scripts/hijri-date.sh ;;
    "System Info") ~/Repositories/scripts/system-info.sh ;;
    "World Clock") ~/Repositories/scripts/worldclock.sh ;;
    *) killall dunst; notify-send -t 1000 "Incorrect"
esac



