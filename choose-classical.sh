#!/bin/bash
source ~/Repositories/scripts/essential-functions

music_composer=$(ls -1 ~/Misc/Backups/my-music/classical | sed 's|-works.txt||g' | rofi -normalize-match -dmenu -i -p "choose composer")
[ -z "$music_composer" ] && exit
quodlibet --enqueue="$(cat ~/Misc/Backups/my-music/classical/"$music_composer"-works.txt | sort -V | rofi -normalize-match -dmenu -i -p 'choose piece')"
