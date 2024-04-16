#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh

function clean-o {
	upc=$(curl -s "$1" | grep -E -i -A 3 -m 1 'strong>upcoming|released' | tail -n +4 | sed 's/^\s*//g')
	year=$(echo $upc | awk '{print $NF}')
	day=$(echo $upc | awk '{print $2}' | tr -d ',')
	[[ "$(echo -n $day | wc -c)" -eq 1 ]] && day="0$day"
	month=$(echo $upc | awk '{print $1}' | cut -c-3 | tr '[a-z]' '[A-Z]')
	upc=$(echo $day $month $year)
	[[ -z "$upc" ]] && upc="\033[31mNO UPCOMING\033[0m"
	echo $upc
}

function print-out {
    echolor blue "$1: " 1
    echolor yellow "$(clean-o https://thetvdb.com/"$2")"
}

print-out "Lower Decks" "/series/star-trek-lower-decks"
print-out "The Mandalorian" "/series/the-mandalorian"
print-out "Severance" "/series/severance"
print-out "Strange New Worlds" "/series/star-trek-strange-new-worlds"
print-out "Manhunt" "/series/manhunt-2022"
print-out "Game Changer" "/series/game-changer"
