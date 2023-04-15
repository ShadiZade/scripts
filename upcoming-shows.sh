#!/bin/bash

clean-o () {
	upc=$(curl "$1" | grep -i -A 3 -m 1 upcoming | tail -n +4 | sed 's/^\s*//g')
	year=$(echo $upc | awk '{print $NF}')
	day=$(echo $upc | awk '{print $2}' | tr -d ',')
	month=$(echo $upc | awk '{print $1}' | cut -c-3 | tr '[a-z]' '[A-Z]')
	upc=$(echo $day $month $year)
	[ -z "$upc" ] && upc="NO UPCOMING"
	echo $upc
}

pkill dunst; dunst &
notify-send -t 3000 "Fetching Shows"
mando=$(echo The Mandalorian: $(clean-o https://thetvdb.com/series/the-mandalorian))
picard=$(echo Picard: $(clean-o https://thetvdb.com/series/star-trek-picard))
snw=$(echo Strange New Worlds: $(clean-o https://thetvdb.com/series/star-trek-strange-new-worlds))
ahsoka=$(echo Ahsoka: $(clean-o https://thetvdb.com/series/ahsoka))
stld=$(echo Lower Decks: $(clean-o https://thetvdb.com/series/star-trek-lower-decks))
ofmd=$(echo Our Flag Means Death: $(clean-o https://thetvdb.com/series/our-flag-means-death))
severance=$(echo Severance: $(clean-o https://thetvdb.com/series/severance))


pkill dunst; dunst -conf ~/.config/dunst/dunstrc-right &
notify-send -t 20000 "Upcoming Shows" "$mando\n$picard\n$snw\n$ahsoka\n$stld\n$ofmd\n$severance"
