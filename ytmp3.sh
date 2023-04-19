#!/bin/bash

download-with-remove () {
yt-dlp --format bestaudio --no-mtime --extract-audio --audio-format mp3 --sponsorblock-remove all "$1"
}

download-no-remove () {
yt-dlp --format bestaudio --no-mtime --extract-audio --audio-format mp3 "$1"
}

[ -z "$remove_p" ] && remove_p=n
cd ~/Downloads || exit
[ "$remove_p" = "n" ] && download-no-remove "$1"
[ "$remove_p" = "y" ] && download-with-remove "$1"
cd - > /dev/null || exit
echo ""
echo ""
echo "========================================================="
echo ":: This is the audio content of your ~/Downloads directory:"
echo "========================================================="
exa ~/Downloads -l --icons --sort=newest --no-user --no-permissions --no-filesize --no-time --time-style=iso | grep .mp3
echo "========================================================="
