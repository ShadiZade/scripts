#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh

function zaytouna {
    nlname="Zaytouna"
    nl='https://www.alzaytouna.net/%D9%86%D8%B4%D8%B1%D8%A9-%D9%81%D9%84%D8%B3%D8%B7%D9%8A%D9%86-%D8%A7%D9%84%D9%8A%D9%88%D9%85/'
    loc="$HOME/Documents/newsletters/zaytouna-palestine-today"
    dlded="$(eza -1f "$loc" | grep 'pdf$' | tail -n 1 | awk -F '-' '{print $2}')"
    echolor green ":: Updating ““$nlname””. Current edition: ““$dlded””" 1
    jinurl="$(curl -s "$nl" | grep '\.pdf'  | awk -F '" rel="' '{print $1}' | awk -F 'href="' '{print $NF}')"
    urled="$(echo "$jinurl" | awk -F '_' '{print $4}')"
    [[ "$dlded" -eq "$urled" ]] && {
	clear-line
	echolor green ":: ✓  Newsletter ““$nlname”” is up to date. Current edition: ““$dlded””"
	return
    } || {
	clear-line
	echolor blue ":: Downloading new edition of ““$nlname””. " 1
	echolor red "$dlded ““→”” " 1
	echolor green "$urled" 1
	cd ~/Desktop/
	filename="$(echo "$jinurl" | awk -F '/' '{print $NF}')"
	wget --no-use-server-timestamps -O "$filename" -nc -q -t 0 -- "$jinurl"
	date=$(date --iso-8601 -d "$(echo "$filename" | awk -F '_' '{print $NF}' | sed 's/\.pdf//g' | awk -F '-' '{print $3"-"$2"-"$1}')")
	mv "$filename" "$loc"/"zaytouna-$urled-$date.pdf"
	clear-line
	echolor blue ":: ✓  Updated newsletter ““$nlname””: " 1
	echolor red "$dlded ““→”” " 1
	echolor green "$urled"
    }
}

function kassioun {
    nlname="Kassioun"
    nl='https://kassioun.org/pdf-archive'
    loc="$HOME/Documents/newsletters/kassioun"
    dlded="$(eza -1f "$loc" | grep 'pdf$' | tail -n 1 | awk -F '-' '{print $2}' | awk -F '.' '{print $1}')"
    echolor green ":: Updating ““$nlname””. Current edition: ““$dlded””" 1
    jinurl="$(curl -s "$nl" | grep 'href="/pdf-archive/' | awk -F 'href="' '{print $NF}' | tr -d '"' | sed 1q)"
    urled="$(echo "$jinurl" | awk -F '-' '{print $3}' | awk -F '/' '{print $1}')"
    [[ "$dlded" -eq "$urled" ]] && {
	clear-line
	echolor green ":: ✓  Newsletter ““$nlname”” is up to date. Current edition: ““$dlded””"
	return
    } || {
	clear-line
	echolor blue ":: Downloading new edition of ““$nlname””. " 1
	echolor red "$dlded ““→”” " 1
	echolor green "$urled" 1
	cd ~/Desktop/
	filename="$(echo kassioun-"$urled")"
	wget --no-use-server-timestamps -O "$filename" -nc -q -t 0 -- "https://kassioun.org$jinurl"
	mv "$filename" "$loc"/"kassioun-$urled.pdf"
	clear-line
	echolor blue ":: ✓  Updated newsletter ““$nlname””: " 1
	echolor red "$dlded ““→”” " 1
	echolor green "$urled"
    }
}

zaytouna
kassioun
