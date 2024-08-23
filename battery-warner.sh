#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh

while true
do
    sleep 3s
    battery-warner
    [[ "$batterystatus" -eq 1 ]] && {
	source ~/Repositories/dotfiles/zsh/variables
	[[ "$battery_warning_on" -eq 0 ]] && continue
	killall dunst
	notify-send -u critical -t 4000 "BATTERY WARNING" "${batterypercent}%"
	quodlibet --pause
	if [[ "$batterypercent" -gt 10 ]]
	then
	    sfx ten-bloops
	else
	    sfx too-low
	fi
    }
done
