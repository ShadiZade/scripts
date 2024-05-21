#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh

rural="$HOME/Repositories/scripts/src/rural-cal"
original_json="$(curl -sL https://repcal.info/now)"
echo "$original_json" | grep -q 'doctype html' && {
    echolor red ":: French date fetch failure"
    exit
}
ao="$(echo "$original_json" | sed 's/repcal:/cal/g' | jq '._embedded')"
do="$(echo "$ao" | jq '.caldate.attributes')"
to="$(echo "$ao" | jq '.caltime.attributes')"

function rural-name {
    fdate="$(echo "$do" | jq -r '.month.name, .day.number_in_month' | tr '\n' ' ' | sed 's/ $//g')"
    echo "$(grep "$fdate|" "$rural" | awk -F "|" '{print $3,"("$NF")"}')"
}
function date-string {
    echo -n "$(echo "$do" | jq -r '.day.name')"", "           # weekday
    echo -n "$(echo "$do" | jq -r '.day.number_in_month')"" " # day in month
    echo -n "$(echo "$do" | jq -r '.month.name')"" "          # month name
    echo -n "(""$(echo "$do" | jq -r '.month.number')"") "    # month name
    echo -n "$(echo "$do" | jq -r '.year.roman')"", "         # year
    rural-name
}

date-string


# french_french=$(grep -i "$french_month-$french_day|" ~/Repositories/scripts/src/rural-cal | awk -F "|" '{print $3}')
# french_english=$(grep -i "$french_month-$french_day|" ~/Repositories/scripts/src/rural-cal | awk -F "|" '{print $NF}')

# telltime () {
# 	killall dunst; dunst &
# 	notify-send -t 6000 "$french_time" "$french_weekday\n$french_day $french_month $french_year\n$french_french ($french_english)"
# }

# wikithat () {
# 	french_wikipedia=$(grep -i "$french_month-$french_day|" ~/Repositories/scripts/src/rural-cal | awk -F "|" '{print $4}')
# 	notify-send -t 4000 "Wikipedia" "Opening $french_english"
# 	xdg-open "https://en.wikipedia.org/wiki/$french_wikipedia"
# }
