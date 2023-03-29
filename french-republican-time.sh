#!/bin/bash
french_api_full=$(curl https://repcal.info/now.json | sed 's/,/\n/g' )
french_formatted=$(echo $french_api_full | grep formatted | sed 2q | awk -F '"' '{print $4}')
french_fulldate=$(echo $french_formatted | tail -n +2)

french_time=$(echo $french_formatted | sed 1q | awk -F ":" '{print $1":"$2}')
french_weekday=$(echo $french_fulldate | awk '{print $1}')
french_day=$(echo $french_fulldate | awk '{print $2}')
french_month=$(echo $french_fulldate | awk '{print $3}' | sed -e "s/\b\(.\)/\u\1/g")
french_year=$(echo $french_api_full | grep year_arabic | awk -F ":" '{print $2}')

french_french=$(grep -i "$french_month-$french_day" ~/Repositories/scripts/src/rural-cal | awk -F "|" '{print $3}')
french_english=$(grep -i "$french_month-$french_day" ~/Repositories/scripts/src/rural-cal | awk -F "|" '{print $NF}')

telltime () {
	pkill dunst; dunst &
	notify-send -t 6000 "$french_time" "$french_weekday\n$french_day $french_month $french_year\n$french_french ($french_english)"
}

wikithat () {
	french_wikipedia=$(grep -i "$french_month-$french_day" ~/Repositories/scripts/src/rural-cal | awk -F "|" '{print $4}')
	notify-send -t 4000 "Wikipedia" "Opening $french_english"
	xdg-open "https://en.wikipedia.org/wiki/$french_wikipedia"
}
