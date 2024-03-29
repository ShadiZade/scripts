#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh

hijri_raw="$(curl http://api.aladhan.com/v1/gToH/$(date +%d-%m-%Y) | sed 's/[{,]/\n/g')"
echo -e "$hijri_raw" | grep -q "API limit exceeded" && notify-send -t 3000 "API rate limit exceeded" "try again later." && exit

hijri_day="$(echo -e "$hijri_raw" | grep -m 1 day | awk -F ":" '{print $2}' | tr -d '"')"
hijri_mon="$(echo -e "$hijri_raw" | grep -m 1 number | awk -F ":" '{print $2}')"
hijri_yrs="$(echo -e "$hijri_raw" | grep -m 1 year | awk -F ":" '{print $2}' | tr -d '"')"
hijri_shh="$(echo -e "$hijri_raw" | grep -m 2 en | tail -n +2 | awk -F ":" '{print $2}' | tr -d '"')"

killall dunst; dunst &
notify-send -t 6000 "$hijri_day $hijri_shh ($hijri_mon) $hijri_yrs"
