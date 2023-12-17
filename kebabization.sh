#!/bin/bash

input_phrase="$1"
echo -e "$input_phrase" | iconv -c -f utf8 -t ascii//TRANSLIT | perl -pe 's|&.*?;||g' | tr -d '"’“”!?*=$:;#@^~()[]{}<>\t\\' \
| sed 's|/| |g;s/\&/-and-/g;s/\%/-percent-/g' | tr -d "'" | tr '_ .|/+,\n–—' '-' | tr '[A-Z]' '[a-z]' | sed 's/--*/-/g;s/-$//g;s/^-//g'  > ~/.kebab
