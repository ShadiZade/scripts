#!/bin/bash

la_time="$(TZ='America/Los_Angeles' date +'%H:%M on %A')"
nyc_time="$(TZ='America/New_York' date +'%H:%M on %A')"
utc_time="$(date -u +'%H:%M on %A')"
my_time="$(date +'%H:%M on %A')"
china_time="$(TZ='Asia/Shanghai' date +'%H:%M on %A')"
nz_time="$(TZ='NZ' date +'%H:%M on %A')"

concat="LAX: $la_time\nNYC: $nyc_time\nUTC: $utc_time\nYOU: $my_time\nCHN: $china_time\nNZL: $nz_time"

killall dunst; dunst -conf "$HOME/.config/dunst/dunstrc-left" &
notify-send -t 6000 "World Clock" "$concat"
