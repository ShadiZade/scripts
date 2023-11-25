#!/bin/bash
echo -e "\033[32m:: Starting...\033[0m"
indoi="$(echo "$1" | sed 's|https://doi.org/||')" && echo -e "\033[32m:: DOI is \033[34m$indoi\033[0m"
shurl="$(curl -s "https://sci-hub.ru/$indoi")" && echo -e "\033[32m:: Sci-Hub queried!\033[0m"
ddurl="$(echo "$shurl" | grep -i 'pdf" src' | awk -F 'src="' '{print $2}' | awk -F '#' '{print $1}' | tr -d "\n")"
ddurl="$(echo "$ddurl" | sed 's|^/downloads|sci-hub.ru/downloads|;s|^/uptodate|sci-hub.ru/uptodate|')"
ddurl="$(echo "$ddurl" | sed 's|^/tree|sci-hub.ru/tree|;s|//||')"
[[ -z "$2" ]] && bibname="unnamed" || bibname="$2"
[[ -z "$ddurl" ]] && echo -e "\033[33m:: No file found in Sci-Hub!\033[0m"
[[ -z "$ddurl" ]] && exit

wget -O "$bibname".pdf -t 0 -- https://"$ddurl" && touch -c "$bibname".pdf


# doiex="$(echo "$shurl" | grep -i 'doi:' | awk -F 'doi:' '{print $2}' | awk -F '&' '{print $1}')"
