#!/bin/bash
source ~/Repositories/dotfiles/bspwm/bspwm-theme.sh
i3lock -kef -c "$bspwm_theme_primary_color"ff --radius 150 --ring-width 5.0 --ring-color=000000ff \
	 --ringver-color=000000ff --insidever-color=00000000 --ringwrong-color=000000ff \
	 --insidewrong-color=00000000 --keyhl-color="$bspwm_theme_secondary_color"ff --bshl-color="$bspwm_theme_primary_color"ff \
	 --date-font="Inconsolata Semi Condensed SemiBold" --verif-font="Inconsolata Extra Condensed ExtraBold" \
	 --time-font="Inconsolata Extra Condensed ExtraBold" --layout-font="Inconsolata Extra Condensed ExtraBold" \
	 --wrong-font="Inconsolata Extra Condensed ExtraBold" --wrong-text="INCORRECT" --verif-text="UNLOCKING" \
	 --noinput-text="" --verif-size=22 --wrong-size=22 --time-size=75 --date-size=18 \
	 --greeter-color="$bspwm_theme_secondary_color"ff --time-color="$bspwm_theme_secondary_color"ff \
	 --date-color="$bspwm_theme_secondary_color"ff --date-str="%a, %e %b %Y"

