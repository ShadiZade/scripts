#!/bin/bash
kernel_v=$(uname -r)
uptime=$(uptime -p | sed 's/up //g')
battery=$(upower -i /org/freedesktop/UPower/devices/battery_BAT1 | grep percentage | awk '{print $2}')
memory_usage=$(df | grep sda1 | awk '{print $5}')
sc_bright=$(brightnessctl i | grep Current | awk '{print $4}' | tr -d '()')
fan_speed=$(cat /proc/acpi/ibm/fan | grep speed | awk '{print $NF}')

killall dunst; dunst -conf "$HOME/.config/dunst/dunstrc-left" &
sleep 1s
notify-send -t 6000 "System information" "Kernel: $kernel_v\nUptime: $uptime\nBattery: $battery\nUsed memory: $memory_usage\nBrightness: $sc_bright\nFan Speed: $fan_speed"
