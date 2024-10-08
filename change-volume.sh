#!/bin/bash

pulsemixer --change-volume "${1:-0}"
killall dunst
notify-send -t 300 "$(pulsemixer --get-volume | awk '{print $1}')"
