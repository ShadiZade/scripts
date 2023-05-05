#!/bin/bash

clean-o () {
	upc=$(curl "$1" | grep -i -A 3 -m 1 "strong>upcoming" | tail -n +4 | sed 's/^\s*//g')
	year=$(echo $upc | awk '{print $NF}')
	day=$(echo $upc | awk '{print $2}' | tr -d ',')
	month=$(echo $upc | awk '{print $1}' | cut -c-3 | tr '[a-z]' '[A-Z]')
	upc=$(echo $day $month $year)
	[ -z "$upc" ] && upc="NO UPCOMING"
	echo $upc
}

killall dunst; dunst &
notify-send -t 3000 "Fetching Shows"
snw=$(echo Strange New Worlds: $(clean-o https://thetvdb.com/series/star-trek-strange-new-worlds))
ahsoka=$(echo Ahsoka: $(clean-o https://thetvdb.com/series/ahsoka))
stld=$(echo Lower Decks: $(clean-o https://thetvdb.com/series/star-trek-lower-decks))
mando=$(echo The Mandalorian: $(clean-o https://thetvdb.com/series/the-mandalorian))
ofmd=$(echo Our Flag Means Death: $(clean-o https://thetvdb.com/series/our-flag-means-death))
severance=$(echo Severance: $(clean-o https://thetvdb.com/series/severance))
picard=$(echo Picard: $(clean-o https://thetvdb.com/series/star-trek-picard))

concat_shows="$snw\n$ahsoka\n$stld\n$mando\n$ofmd\n$severance\n$picard"

killall dunst; dunst -conf "$HOME/.config/dunst/dunstrc-right" &
sleep 2s
notify-send -t 20000 "Upcoming Shows" "$concat_shows"
