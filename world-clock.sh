#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh

lon_time="$(TZ='Europe/London' date +'%H:%M on %A')"
jo_time="$(TZ='Asia/Amman' date +'%H:%M on %A')"
my_time="$(date +'%H:%M on %A')"
nz_time="$(TZ='NZ' date +'%H:%M on %A')"

prev_day="$(TZ='Pacific/Honolulu' date +'%d')"

function timein {
    tzdata="$2"
    [[ ! -z "$tzdata" ]] && {
	tzdata="TZ=$tzdata"
    }
    hour="$(eval $tzdata date +'%H:%M')"
    weekday="$(eval $tzdata date +'%a')"
    day="$(eval $tzdata date +'%d')"
    month="$(eval $tzdata date +'%m')"
    [[ "10#$day" -ne "10#$prev_day" ]] && {
	echolor blue "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    }
    echolor yellow-purple ":: ““$1””\t— " 1
    echolor yellow "““$hour”” on " 1
    echolor yellow-green "““$weekday””, $month-$day" 1
    [[ "$hour" = "$(date +'%H:%M')" ]] && echolor blue " <----" || echo
	
    prev_day="$day"
}
echolor yellow "======================================"
timein "Honolulu" "Pacific/Honolulu"
timein "Los Angeles" "America/Los_Angeles"
timein "Denver" "America/Denver"
timein "Chicago" "America/Chicago"
timein "New York" "America/New_York"
timein "São Paulo" "America/Sao_Paulo"
timein "UTC    " "UTC"
timein "London" "Europe/London"
timein "Berlin" "Europe/Berlin"
timein "Pretoria" "Africa/Johannesburg"
timein "Amman" "Asia/Amman"
timein "Tehran" "Asia/Tehran"
timein "Kabul" "Asia/Kabul"
timein "Hanoi" "Asia/Ho_Chi_Minh"
timein "Beijing" "Asia/Shanghai"
timein "Pyongyang" "Asia/Pyongyang"
timein "Sydney" "Australia/Sydney"
timein "Christchurch" "NZ"
timein "Tarawa" "Pacific/Kanton"
echolor yellow "======================================"
