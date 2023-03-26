#!/bin/bash

french_full=$(curl https://repcal.info/now.json | sed 's/,/\n/g' | grep formatted | sed 2q | awk -F '"' '{print $4}')
french_time=$(echo $french_full | sed 1q | awk -F ":" '{print $1":"$2}')
french_date=$(echo $french_full | tail -n +2)
french_month=$(echo $french_date | awk '{print $3}')
french_day=$(echo $french_date | awk '{print $2}')
french_french=$(grep -i "$french_month-$french_day" ~/Repositories/scripts/src/rural-cal | awk -F "|" '{print $3}')
french_english=$(grep -i "$french_month-$french_day" ~/Repositories/scripts/src/rural-cal | awk -F "|" '{print $NF}')
french_wikipedia=$(grep -i "$french_month-$french_day" ~/Repositories/scripts/src/rural-cal | awk -F "|" '{print $4}')

telltime () {
	notify-send -t 4000 "$french_time" "$french_date\n$french_french ($french_english)"
}

wikithat () {
	notify-send -t 2000 "Wikipedia" "Opening $french_english"
	xdg-open "https://en.wikipedia.org/wiki/$french_wikipedia"
}
