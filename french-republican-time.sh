#!/bin/bash
french_api_full=$(curl -L https://repcal.info/now | sed 's/,/\n/g' )
french_formatted=$(echo $french_api_full | grep formatted | sed 2q | awk -F '"' '{print $4}')
french_fulldate=$(echo $french_api_full | grep -m 1 texts | awk -F ':' '{print $NF}' | tr -d '{}"')

french_time=$(echo $french_api_full | tail -n 3 | sed 2q | awk -F ':' '{print $NF}' | tr -d '}' | tr '\n' ':' | sed 's/:$//g')
french_weekday=$(echo $french_fulldate | awk '{print $1}')
french_day=$(echo $french_fulldate | awk '{print $2}')
french_month=$(echo $french_fulldate | awk '{print $3}' | sed -e "s/\b\(.\)/\u\1/g")
french_year=$(echo $french_api_full | grep arabic | awk -F ":" '{print $NF}')

french_french=$(grep -i "$french_month-$french_day|" ~/Repositories/scripts/src/rural-cal | awk -F "|" '{print $3}')
french_english=$(grep -i "$french_month-$french_day|" ~/Repositories/scripts/src/rural-cal | awk -F "|" '{print $NF}')

telltime () {
	killall dunst; dunst &
	notify-send -t 6000 "$french_time" "$french_weekday\n$french_day $french_month $french_year\n$french_french ($french_english)"
}

wikithat () {
	french_wikipedia=$(grep -i "$french_month-$french_day|" ~/Repositories/scripts/src/rural-cal | awk -F "|" '{print $4}')
	notify-send -t 4000 "Wikipedia" "Opening $french_english"
	xdg-open "https://en.wikipedia.org/wiki/$french_wikipedia"
}
