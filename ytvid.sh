#!/bin/bash

read -r -p ":: Download subtitles? (y/N) " subs
read -r -p ":: Remove sponsor segment? (y/N) " spon
# sets default value of y to variables
subs=${subs:-n}
spon=${spon:-n}
###
subspon=$subs$spon
cd ~/Excluding/ytvid || exit
case $subspon in

		yy)
			yt-dlp -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best" --write-subs --no-mtime --sponsorblock-remove sponsor "$1"
			;;
		yn)
			yt-dlp -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best" --write-subs --no-mtime "$1"
			;;
		ny) 
			yt-dlp -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best" --no-mtime --sponsorblock-remove sponsor "$1"
			;;
		nn) 
			yt-dlp -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best" --no-mtime "$1"
			;;
		*)
			echo ":: Incorrect input."
			exit
			;;
esac
cd - > /dev/null
echo ""
echo ""
echo "========================================================="
echo ":: This is the video content of your ~/Excluding/ytvid directory:"
echo "========================================================="
exa ~/Excluding/ytvid -l --icons --sort=oldest --no-user --no-permissions --no-filesize --no-time --time-style=iso | grep .mp4
echo "========================================================="
