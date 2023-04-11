#!/bin/bash

input_phrase="$1"
echo -e "$input_phrase" | tr -d '"’“”!?*%$:;#@^()[]{}<>\t' | tr -d "'" | tr '_ .,\n–—' '-' \
| tr '[A-Z]' '[a-z]' | sed 's/--*/-/g;s/\&/and/g;s/-$//g' | tr -dc '[:graph:]' | iconv -f utf8 -t ascii//TRANSLIT > ~/.kebab
