#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh

lon_time="$(TZ='Europe/London' date +'%H:%M on %A')"
jo_time="$(TZ='Asia/Amman' date +'%H:%M on %A')"
my_time="$(date +'%H:%M on %A')"
nz_time="$(TZ='NZ' date +'%H:%M on %A')"

prev_day="$(TZ='America/Los_Angeles' date +'%d')"

function timein {
    tzdata="$2"
    [[ ! -z "$tzdata" ]] && {
	tzdata="TZ=$tzdata"
    }
    hour="$(eval $tzdata date +'%H:%M')"
    weekday="$(eval $tzdata date +'%a')"
    day="$(eval $tzdata date +'%d')"
    [[ "$day" -ne "$prev_day" ]] && {
	echolor blue "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    }
    echolor yellow-purple ":: ““$1”” \t— " 1
    echolor yellow "““$hour”” on " 1
    echolor green "$weekday"
    prev_day="$day"
}
echolor yellow "==============================="
timein "Los Angeles" "America/Los_Angeles"
timein "New York" "America/New_York"
timein "UTC    " "UTC"
timein "London" "Europe/London"
timein "Jordan" "Asia/Amman"
timein "China" "Asia/Shanghai"
timein "New Zealand" "NZ"
echolor yellow "==============================="
