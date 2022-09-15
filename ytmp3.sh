#!/bin/bash

cd ~/Downloads
yt-dlp --format bestaudio --no-mtime --extract-audio --audio-format mp3 "$1"
cd - > /dev/null
echo "========================================================="
echo ":: This is the audio content of your ~/Downloads directory:"
echo "========================================================="
exa ~/Downloads -l --icons --sort=oldest --no-user --no-permissions --no-filesize --no-time --time-style=iso | grep .mp3
echo "========================================================="

