#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh

while true
do
    sleep 3s
    [[ -z  "$adap" ]] && adap="$(acpi -a | awk '{print $NF}')"
    newadap="$(acpi -a | awk '{print $NF}')"
    [[ ! "$adap" = "$newadap" ]] && {
	case "$adap$newadap" in
	    "on-lineoff-line") sfx adapter-removed ;;
	    "off-lineon-line") sfx adapter-connect ;;
	esac
    }
    adap="$newadap"
    [[ "$adap" = "on-line" ]] && continue
    battery-low-detect
    [[ "$batterylow" -eq 1 ]] && {
	source ~/Repositories/dotfiles/zsh/variables
	[[ "$battery_warning_on" -eq 0 ]] && continue
	killall dunst
	remaining="$(acpi -b | sed -n 2p | awk -F ', ' '{print $NF}')"
	notify-send -u critical -t 4000 "BATTERY WARNING" "${batterypercent}%\n$remaining"
	quodlibet --pause
	[[ "$batterypercent" -eq 25 ]] && {
	    sfx dont-sink
	    continue
	}
	[[ "$batterypercent" -gt 19 ]] && {
	    sfx terrain
	    continue
	}
	[[ "$batterypercent" -gt 9 ]] && {
	    sfx too-low
	    continue
	}
	[[ "$batterypercent" -ge 0 ]] && {
	    sfx pull-up
	    continue
	}
    }
done
