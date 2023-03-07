#!/bin/bash

input_phrase="$1"
echo "$input_phrase" | tr -d '"’“”!?*%$:;#@^()[]{}<>\n\t' | tr -d "'" | tr '_ .,' '-' \
| tr '[A-Z]' '[a-z]' | iconv -f utf8 -t ascii//TRANSLIT > ~/.kebabtemp
sed -i 's/--*/-/g' ~/.kebabtemp
sed -i 's/\&/and/g' ~/.kebabtemp
# cat ~/.kebabtemp | tr -dc '[:graph:]' > ~/.kebabtemp
cat ~/.kebabtemp | tr -dc '[:graph:]' | xclip -selection clipboard
cat ~/.kebabtemp | tr -dc '[:graph:]'
