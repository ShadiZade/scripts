#!/bin/bash
source ~/Repositories/scripts/bspwm-theme.sh
quodlibet --pause
i3lock -kef -c "$bspwm_theme_primary_color"ff --radius 290 --ring-width 45.0 --inside-color=00000000 \
	 --ring-color="$bspwm_theme_secondary_color"ff --ringver-color="$bspwm_theme_secondary_color"ff --insidever-color=00000000 \
	 --ringwrong-color="$bspwm_theme_secondary_color"ff --insidewrong-color=00000000 --keyhl-color="$bspwm_theme_primary_color"ff \
	 --bshl-color="$bspwm_theme_primary_color"ff --date-font="Inconsolata Semi Condensed SemiBold" \
	 --verif-font="Inconsolata Extra Condensed ExtraBold" --time-font="Inconsolata Extra Condensed ExtraBold" \
	 --layout-font="Inconsolata Extra Condensed ExtraBold" --wrong-font="Inconsolata Extra Condensed ExtraBold" --wrong-text="!" \
	 --verif-text="" --noinput-text="" --wrong-size=80 --time-size=75 --date-size=18 \
	 --verif-color="$bspwm_theme_secondary_color"ff --greeter-color="$bspwm_theme_secondary_color"ff \
	 --time-color="$bspwm_theme_secondary_color"ff --wrong-color="$bspwm_theme_secondary_color"ff \
	 --date-color="$bspwm_theme_secondary_color"ff --date-str="%a, %e %b %Y" --greeter-pos="685:200" --greeter-size=20 \
	 --greeter-text="$(cat ~/.lock-greeting)" 		 

