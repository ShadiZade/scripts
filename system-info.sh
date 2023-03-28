#!/bin/bash
kernel_v=$(uname -r)
uptime=$(uptime -p | sed 's/up //g')
battery=$(upower -i /org/freedesktop/UPower/devices/battery_BAT1 | grep percentage | awk '{print $2}')
sc_bright=$(brightnessctl i | grep Current | awk '{print $4}' | tr -d '()')

notify-send -t 6000 "System information" "Kernel: $kernel_v\nUptime: $uptime\nBattery: $battery\nBrightness: $sc_bright"
