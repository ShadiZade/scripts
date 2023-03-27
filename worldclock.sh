#!/bin/bash
la_time="$(TZ='America/Los_Angeles' date +'%H:%m on %A')"
nyc_time="$(TZ='America/New_York' date +'%H:%m on %A')"
utc_time="$(date -u +'%H:%m on %A')"
my_time="$(date +'%H:%m on %A')"
china_time="$(TZ='Asia/Shanghai' date +'%H:%m on %A')"

notify-send -t 6000 "World Clock" "LAX: $la_time\nNYC: $nyc_time\nUTC: $utc_time\nYOU: $my_time\nCHN: $china_time"
