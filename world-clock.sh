#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh

la_time="$(TZ='America/Los_Angeles' date +'%H:%M on %A')"
nyc_time="$(TZ='America/New_York' date +'%H:%M on %A')"
utc_time="$(date -u +'%H:%M on %A')"
lon_time="$(TZ='Europe/London' date +'%H:%M on %A')"
jo_time="$(TZ='Asia/Amman' date +'%H:%M on %A')"
my_time="$(date +'%H:%M on %A')"
nz_time="$(TZ='NZ' date +'%H:%M on %A')"

function timein {
    tzdata="$2"
    [[ ! -z "$tzdata" ]] && {
	tzdata="TZ=$tzdata"
    }
    hour="$(eval $tzdata date +'%H:%M')"
    day="$(eval $tzdata date +'%A')"
    echolor yellow-purple ":: ““$1”” \t— " 1
    echolor yellow "““$hour”” on ““$day””"
}

timein "Los Angeles" "America/Los_Angeles"
timein "New York" "America/New_York"
timein "Greenwich" "UTC"
