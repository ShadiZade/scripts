#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh

clean-o () {
	upc=$(curl "$1" | grep -E -i -A 3 -m 1 'strong>upcoming|released' | tail -n +4 | sed 's/^\s*//g')
	year=$(echo $upc | awk '{print $NF}')
	day=$(echo $upc | awk '{print $2}' | tr -d ',')
	[[ "$(echo -n $day | wc -c)" -eq 1 ]] && day="0$day"
	month=$(echo $upc | awk '{print $1}' | cut -c-3 | tr '[a-z]' '[A-Z]')
	upc=$(echo $day $month $year)
	[[ -z "$upc" ]] && upc="NO UPCOMING"
	echo $upc
}

killall dunst; dunst &
notify-send -t 3000 "Fetching Shows"
stld="$(echo -e Lower Decks: $(clean-o https://thetvdb.com/series/star-trek-lower-decks))"
mando="$(echo -e The Mandalorian: $(clean-o https://thetvdb.com/series/the-mandalorian))"
severance="$(echo -e Severance: $(clean-o https://thetvdb.com/series/severance))"
ofmd="$(echo -e Our Flag Means Death: $(clean-o https://thetvdb.com/series/our-flag-means-death))"
ahsoka="$(echo -e Ahsoka: $(clean-o https://thetvdb.com/series/ahsoka))"
snw="$(echo -e Strange New Worlds: $(clean-o https://thetvdb.com/series/star-trek-strange-new-worlds))"
manhunt="$(echo -e Manhunt: $(clean-o https://thetvdb.com/series/manhunt-2022))"

concat_shows="$mando\n$severance\n$snw\n$ahsoka\n$stld\n$ofmd\n$manhunt"

killall dunst; dunst -conf "$HOME/.config/dunst/dunstrc-right" &
sleep 2s
notify-send -t 20000 "Upcoming Shows" "$concat_shows"
