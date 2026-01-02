#!/bin/bash
source ~/Repositories/scripts/essential-functions

jsonfile="/tmp/hijri-$(date-string ymd).json"
curl -s -X GET "https://api.aladhan.com/v1/gToH/$(date +%d-%m-%Y)?calendarMethod=UAQ" -H 'accept: application/json' > "$jsonfile"
grep -q "API limit exceeded" "$jsonfile" && {
    notify-send -t 3000 "Hijri API rate limit exceeded" "try again later."
    exit 1
}

hijri_day="$(jq -r '.data.hijri.day' "$jsonfile")"
hijri_monthname="$(jq -r '.data.hijri.month.en' "$jsonfile")"
hijri_monthnum="$(jq -r '.data.hijri.month.number' "$jsonfile")"
hijri_year="$(jq -r '.data.hijri.year' "$jsonfile")"
[[ -z "$hijri_day" || -z "$hijri_monthname" || -z "$hijri_monthnum" || -z "$hijri_year" ]] && exit 1
echo "$hijri_day $hijri_monthname ($hijri_monthnum) $hijri_year"
