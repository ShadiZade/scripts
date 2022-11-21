#!/bin/bash

read -r -p ":: Download subtitles? (y/N) " subs_p
read -r -p ":: Remove sponsor segment? (y/N) " spon_p
subs=""
spon1=""
spon2=""
[ "$subs_p" == "y" ] && subs="--write-subs"
[ "$spon_p" == "y" ] && spon1="--sponsorblock-remove" && spon2="sponsor"
cd ~/Excluding/ytvid || exit
yt-dlp -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best" --no-mtime "$subs" "$spon1" "$spon2" "$1"
cd - > /dev/null || exit
echo "========================================================="
echo ":: This is the video content of your ~/Excluding/ytvid directory:"
echo "========================================================="
exa ~/Excluding/ytvid -l --icons --sort=oldest --no-user --no-permissions --no-filesize --no-time --time-style=iso | grep .mp4
echo "========================================================="
