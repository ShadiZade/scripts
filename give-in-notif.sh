#!/bin/zsh
source ~/Repositories/scripts/essential-functions.sh

your_options="French Republican Calendar\nFrench Republican Rural Day\nHijri Calendar\nSystem Info\nWorld Clock"
choice=$(echo -e "$your_options" | rofi -i -dmenu -p "Choose thingy")
case $choice in
    "French Republican Calendar") source ~/Repositories/scripts/french-republican-time.sh; telltime ;;
    "French Republican Rural Day") source ~/Repositories/scripts/french-republican-time.sh; wikithat ;;
    "Hijri Calendar") ~/Repositories/scripts/hijri-date.sh ;;
    "System Info") ~/Repositories/scripts/system-info.sh ;;
    "World Clock") ~/Repositories/scripts/worldclock.sh ;;
    *) killall dunst; notify-send -t 1000 "Incorrect"
esac



