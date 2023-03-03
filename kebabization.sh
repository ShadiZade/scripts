#!/bin/bash

input_phrase="$1"
echo "$input_phrase" | tr -d '"’“”!?*%$:;#@^(){}<>\n\t' | tr -d "'" | tr '_ .,' '-' | tr '[A-Z]' '[a-z]' > ~/.kebabtemp
sed -i 's/--*/-/g' ~/.kebabtemp
sed -i 's/\&/and/g' ~/.kebabtemp
cat ~/.kebabtemp | xclip -selection clipboard
cat ~/.kebabtemp
