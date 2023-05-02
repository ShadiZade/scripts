#!/bin/bash

cat ~/Repositories/scripts/src/wiki-shortcuts | sort | rofi -i -dmenu | xclip -r -selection clipboard
