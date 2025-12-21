#!/bin/bash
source ~/Repositories/scripts/essential-functions

jsonfile="/tmp/hijri-$(date-string ymd).json"
curl -s -X GET "https://api.aladhan.com/v1/gToH/$(date +%d-%m-%Y)?calendarMethod=UAQ" -H 'accept: application/json' > "$jsonfile"
grep -q "API limit exceeded" "$jsonfile" && {
    notify-send -t 3000 "Hijri API rate limit exceeded" "try again later."
    exit 1
}

echo "$(jq -r '.data.hijri.day' "$jsonfile") $(jq -r '.data.hijri.month.en' "$jsonfile") ($(jq -r '.data.hijri.month.number' "$jsonfile")) $(jq -r '.data.hijri.year' "$jsonfile")"
