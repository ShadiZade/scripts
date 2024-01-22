#!/bin/bash

clean-o () {
	upc=$(curl "$1" | grep -E -i -A 3 -m 1 'strong>upcoming|released' | tail -n +4 | sed 's/^\s*//g')
	year=$(echo $upc | awk '{print $NF}')
	day=$(echo $upc | awk '{print $2}' | tr -d ',')
	month=$(echo $upc | awk '{print $1}' | cut -c-3 | tr '[a-z]' '[A-Z]')
	upc=$(echo $day $month $year)
	[ -z "$upc" ] && upc="NO UPCOMING"
	echo $upc
}

killall dunst; dunst &
notify-send -t 3000 "Fetching Shows"
stld=$(echo Lower Decks: $(clean-o https://thetvdb.com/series/star-trek-lower-decks))
mando=$(echo The Mandalorian: $(clean-o https://thetvdb.com/series/the-mandalorian))
severance=$(echo Severance: $(clean-o https://thetvdb.com/series/severance))
ofmd=$(echo Our Flag Means Death: $(clean-o https://thetvdb.com/series/our-flag-means-death))
ahsoka=$(echo Ahsoka: $(clean-o https://thetvdb.com/series/ahsoka))
snw=$(echo Strange New Worlds: $(clean-o https://thetvdb.com/series/star-trek-strange-new-worlds))

concat_shows="$mando\n$severance\n$snw\n$ahsoka\n$stld\n$ofmd\n"

killall dunst; dunst -conf "$HOME/.config/dunst/dunstrc-right" &
sleep 2s
notify-send -t 20000 "Upcoming Shows" "$concat_shows"
