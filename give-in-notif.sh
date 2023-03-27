#!/bin/zsh

your_options="French Republican Calendar\nFrench Republican Rural Day\nWorld Clock"
choice=$(echo -e "$your_options" | rofi -dmenu -p "Choose thingy")
case $choice in
    "French Republican Calendar") source ~/Repositories/scripts/french-republican-time.sh; telltime ;;
    "French Republican Rural Day") source ~/Repositories/scripts/french-republican-time.sh; wikithat ;;
    "World Clock") ~/Repositories/scripts/worldclock.sh ;;
    *) notify-send -t 1000 "Incorrect"
esac



