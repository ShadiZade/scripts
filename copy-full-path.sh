#!/bin/bash 

[ "$1" = '.' ] && path_copied="$(pwd)" || path_copied="$(echo \'$(pwd)/$(ls -1 | grep "$1" | sed 1q | tr -d '\n')\')"
echo "$path_copied" | tr -d '\n' | xclip -selection clipboard
echo "$path_copied"

