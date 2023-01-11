#!/bin/bash

cd ~/Music/$(ls -1 ~/Music | rofi -dmenu)
quodlibet --enqueue="$(taffy *.mp3 | grep title | awk -F ':' '{print $2}' | sed 's|^[[:space:]]*||g' | rofi -dmenu -i)"
