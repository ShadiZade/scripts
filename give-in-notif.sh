#!/bin/zsh

your_options="French Republican Calendar\nFrench Republican Honor"
choice=$(echo -e "$your_options" | rofi -dmenu -p "Choose thingy")
case $choice in
    "French Republican Calendar") source ~/Repositories/scripts/french-republican-time.sh; telltime ;;
    "French Republican Honor") source ~/Repositories/scripts/french-republican-time.sh; wikithat ;;
    *) notify-send -t 1000 "Incorrect"
esac



