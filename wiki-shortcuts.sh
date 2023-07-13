#!/bin/bash
echo $which_shortcuts
cat "$HOME/Repositories/scripts/src/$which_shortcuts" | sort | rofi -i -dmenu | xclip -r -selection clipboard
