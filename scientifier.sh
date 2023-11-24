#!/bin/bash

echo -e "\033[32m:: Starting...\033[0m"
shurl="$(curl -s "https://sci-hub.ru/$1")" && echo -e "\033[32m:: Sci-Hub queried!\033[0m"
ddurl="$(echo "$shurl" | grep -i 'src' | awk -F '//' '{print $2}' | awk -F '#' '{print $1}' | tr -d "\n")"
[[ -z "$2" ]] && bibname="unnamed" || bibname="$2"
[[ -z "$ddurl" ]] && echo -e "\033[33m:: No file found in Sci-Hub!\033[0m"
[[ -z "$ddurl" ]] && exit
wget -O "$bibname".pdf -t 0 -- https://"$ddurl" && touch "$bibname".pdf


# doiex="$(echo "$shurl" | grep -i 'doi:' | awk -F 'doi:' '{print $2}' | awk -F '&' '{print $1}')"
