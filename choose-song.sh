#!/bin/bash
source ~/Repositories/scripts/essential-functions

music_category=$(ls -1 ~/Misc/Backups/my-music/titles | sed 's|-titles.txt||g' | rofi -dmenu -i -p "choose category")
[[ -z "$music_category" ]] && exit 1
quodlibet --enqueue="$(cat ~/Misc/Backups/my-music/titles/"$music_category"-titles.txt | rofi -normalize-match -dmenu -i -p 'choose song')"
