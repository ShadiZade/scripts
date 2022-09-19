#!/bin/bash

source ~/Repositories/scripts/book-goal-calc.sh
i3lock -kef -c aa2200ff --radius 150 --ring-width 5.0 --ring-color=000000ff \
	 --ringver-color=000000ff --insidever-color=00000000 --ringwrong-color=000000ff \
	 --insidewrong-color=00000000 --keyhl-color=ffffffff --bshl-color=aa2200ff \
	 --date-font="Inconsolata Semi Condensed SemiBold" --verif-font="Inconsolata Extra Condensed ExtraBold" \
	 --time-font="Inconsolata Extra Condensed ExtraBold" --layout-font="Inconsolata Extra Condensed ExtraBold" \
	 --wrong-font="Inconsolata Extra Condensed ExtraBold" --wrong-text="INCORRECT" --verif-text="UNLOCKING" \
	 --noinput-text="" --verif-size=22 --wrong-size=22 --time-size=75 --date-size=18 \
	 --date-str="%a, %e %b %Y ($bP% on #$cB)"

