#!/bin/bash

ct="$(date '+%B %Y')"
cat ~/Repositories/scripts/src/wiki-shortcuts | sort | sed "s/DATEHERE/$ct/g" | rofi -i -dmenu | xclip -r -selection clipboard
