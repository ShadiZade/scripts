#!/bin/bash

input_phrase="$1"
echo -e "$input_phrase" | iconv -c -f utf8 -t ascii//TRANSLIT | tr -d '"’“”!?*+=%$:;#@|^~()[]{}<>\t' \
| sed 's/\&/-and-/g' | tr -d "'" | tr '_ ./,\n–—' '-' | tr '[A-Z]' '[a-z]' | sed 's/--*/-/g;s/-$//g;s/^-//g'  > ~/.kebab
