#!/bin/bash

# From strftime(3), https://man7.org/linux/man-pages/man3/strftime.3.html
daysSinceNYE=$(date +"%j")	
hoursSinceMN=$(date +"%H")
# Calculates how many hours passed from New Year's Eve to 00:00 today
hoursInDaysSinceNYE=$(echo "scale=0; $daysSinceNYE*24" | bc )
# Calculates how many hours passed from New Year's Eve to this moment
hoursSinceNYE=$(echo "scale=0; $hoursInDaysSinceNYE+$hoursSinceMN" | bc )
# Calculates how many weeks passed from New Year's Eve to this moment to 2 decimal points (168=24*7)
weeksSinceNYE2=$(echo "scale=2; $hoursSinceNYE/168" | bc )
# Calculates how many weeks passed from New Year's Eve to this moment to 0 decimal points (168=24*7)
weeksSinceNYE0=$(echo "scale=0; $hoursSinceNYE/168" | bc )
# Extracts the decimal from weeksSinceNYE2 in order to calculate progress goal on current book
bookDecimal=$(echo "scale=2; $weeksSinceNYE2-$weeksSinceNYE0" | bc )
# Converts the decimal to a percentage
bookPercentage2=$(echo "scale=0; $bookDecimal*100" | bc )
# Removes floating point from percentage
bookPercentage0=$(echo "scale=0; $bookPercentage2/1" | bc )
# Adds 1 to the number of weeks to calculate current book goal
currentBook=$(echo "scale=0; $weeksSinceNYE0+1" | bc )
# Lockscreen program (i3lock-color)
i3lock -kef -c 85132dff --radius 150 --ring-width 5.0 --ring-color=000000ff \
	 --ringver-color=000000ff --insidever-color=00000000 --ringwrong-color=000000ff \
	 --insidewrong-color=00000000 --keyhl-color=ffffffff --bshl-color=85132dff \
	 --date-font="Inconsolata Semi Condensed SemiBold" --verif-font="Inconsolata Extra Condensed ExtraBold" \
	 --time-font="Inconsolata Extra Condensed ExtraBold" --layout-font="Inconsolata Extra Condensed ExtraBold" \
	 --wrong-font="Inconsolata Extra Condensed ExtraBold" --wrong-text="INCORRECT" --verif-text="UNLOCKING" \
	 --noinput-text="" --verif-size=22 --wrong-size=22 --time-size=75 --date-size=18 \
	 --greeter-color=ff90b1ff --time-color=ff90b1ff --date-color=ff90b1ff \
	 --date-str="%a, %e %b %Y ("$bookPercentage0"% on book #"$currentBook")"

