#!/bin/bash
source ~/.local/share/user-scripts/current-theme

quodlibet --pause
function batc {
	upower -i /org/freedesktop/UPower/devices/battery_BAT1 | grep percentage | awk '{print $2}'
}
i3lock -kef -c "$lin_color1"ff \
       --radius 290 \
       --ring-width 45.0 \
       --inside-color=00000000  \
       --ring-color="$lin_color2"ff \
       --ringver-color="$lin_color2"ff \
       --insidever-color=00000000  \
       --ringwrong-color="$lin_color2"ff \
       --insidewrong-color=00000000 \
       --keyhl-color="$lin_color1"ff  \
       --bshl-color="$lin_color1"ff \
       --date-font="Inconsolata Semi Condensed SemiBold"  \
       --verif-font="Inconsolata Extra Condensed ExtraBold" \
       --time-font="Inconsolata Extra Condensed ExtraBold"  \
       --layout-font="Inconsolata Extra Condensed ExtraBold" \
       --wrong-font="Inconsolata Extra Condensed ExtraBold" \
       --wrong-text="!"  \
       --verif-text="" \
       --noinput-text="" \
       --wrong-size=80 \
       --time-size=75 \
       --date-size=18  \
       --verif-color="$lin_color2"ff \
       --greeter-color="$lin_color2"ff  \
       --time-color="$lin_color2"ff \
       --wrong-color="$lin_color2"ff  \
       --date-color="$lin_color2"ff \
       --date-str="%a, %e %b %Y, $(batc)" \
       --greeter-pos="685:200" \
       --greeter-size=20  \
       --greeter-text="$(cat ~/.lock-greeting)" 		 

