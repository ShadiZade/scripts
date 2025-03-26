#!/bin/bash
source ~/Repositories/scripts/essential-functions

function zaytouna {
    nlname="Zaytouna"
    nl='https://www.alzaytouna.net/%D9%86%D8%B4%D8%B1%D8%A9-%D9%81%D9%84%D8%B3%D8%B7%D9%8A%D9%86-%D8%A7%D9%84%D9%8A%D9%88%D9%85/'
    loc="$HOME/Documents/newsletters/zaytouna-palestine-today"
    dlded=''
    dlded="$(eza -1f "$loc" | grep 'pdf$' | tail -n 1 | awk -F '-' '{print $2}')"
    echolor orange ":: ❯❯ Updating ““$nlname”” now. Current edition: ““$dlded””" 1
    jinurl="$(curl -m 15 -s "$nl" | grep '\.pdf'  | awk -F '" rel="' '{print $1}' | awk -F 'href="' '{print $NF}')"
    urled=''
    urled="$(echo "$jinurl" | awk -F '_' '{print $4}')"
    [[ -z "$urled" ]] && {
	clear-line
	echolor red ":: ⨯  Error extracting ““$nlname”” data, update failed."
	return
    }
    [[ "$(echo -n "$urled" | wc -c)" -ne 4 ]] && {
	clear-line
	echolor red ":: ⨯ ““$nlname:”” Inexplicable result ““$urled””"
	return
    }
    [[ "$dlded" -eq "$urled" ]] && {
	clear-line
	echolor green ":: ✓  Newsletter ““$nlname”” is up to date. Current edition: ““$dlded””"
	return
    } || {
	clear-line
	echolor blue ":: ❯❯ Downloading new edition of ““$nlname””. " 1
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
	echo "$loc"/"zaytouna-$urled-$date.pdf" >> "$usdd"/unread-newsletters
    }
}

function kassioun {
    nlname="Kassioun"
    nl='https://kassioun.org/pdf-archive'
    loc="$HOME/Documents/newsletters/kassioun"
    dlded=''
    dlded="$(eza -1f "$loc" | grep 'pdf$' | tail -n 1 | awk -F '-' '{print $2}' | awk -F '.' '{print $1}')"
    echolor orange ":: ❯❯ Updating ““$nlname”” now. Current edition: ““$dlded””" 1
    jinurl="$(curl -m 15 -s "$nl" | grep 'href="/pdf-archive/' | awk -F 'href="' '{print $NF}' | tr -d '"' | sed 1q)"
    urled=''
    urled="$(echo "$jinurl" | awk -F '-' '{print $3}' | awk -F '/' '{print $1}')"
    [[ -z "$urled" ]] && {
	clear-line
	echolor red ":: ⨯  Error extracting ““$nlname”” data, update failed."
	return
    }
    [[ "$(echo -n "$urled" | wc -c)" -ne 4 ]] && {
	clear-line
	echolor red ":: ⨯ ““$nlname:”” Inexplicable result ““$urled””"
	return
    }
    [[ "$dlded" -eq "$urled" ]] && {
	clear-line
	echolor green ":: ✓  Newsletter ““$nlname”” is up to date. Current edition: ““$dlded””"
	return
    } || {
	clear-line
	
	echolor blue ":: ❯❯ Downloading new edition of ““$nlname””. " 1
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
	echo "$loc"/"kassioun-$urled.pdf" >> "$usdd"/unread-newsletters
    }
}

function al-akhbar {
    nlname="Al-Akhbar"
    nl='https://al-akhbar.com/todays-newsletter'
    loc="$HOME/Documents/newsletters/al-akhbar"
    akhbar_tmp="/tmp/akhbar-data-$(date-string)"
    dlded=''
    dlded="$(eza -1f "$loc" | grep 'pdf$' | tail -n 1 | awk -F '-' '{print $3}')"
    echolor orange ":: ❯❯ Updating ““$nlname”” now. Current edition: ““$dlded””" 1
    wget -qO- "$nl" | tr '\\' '\n' > "$akhbar_tmp"
    urled=''
    urled="$(cat "$akhbar_tmp" | grep -i -A 2 -m 1 'publicurl' | sed -n 3p | awk -F '/' '{print $NF}')"
    urldt="$(cat "$akhbar_tmp" | grep -i -A 2 -m 1 'publishdate' | sed -n 3p | awk -F '"' '{print $NF}' | awk -F ' ' '{print $1}')"
    [[ -z "$urled" ]] && {
	clear-line
	echolor red ":: ⨯  Error extracting ““$nlname”” data, update failed."
	return
    }
    [[ "$(echo -n "$urled" | wc -c)" -ne 4 ]] && {
	clear-line
	echolor red ":: ⨯ ““$nlname:”” Inexplicable result ““$urled””"
	return
    }
    [[ "$dlded" -eq "$urled" ]] && {
	clear-line
	echolor green ":: ✓  Newsletter ““$nlname”” is up to date. Current edition: ““$dlded””"
	return
    } || {
	clear-line
	echolor blue ":: ❯❯ Downloading new edition of ““$nlname””. " 1
	echolor red "$dlded ““→”” " 1
	echolor green "$urled" 1
	cd ~/Desktop/
	filename="$(echo al-akhbar-"$urled"-$(date --iso-8601 -d "$urldt"))"
	wget -qO- "https://www.al-akhbar.com/newspaper/$urled" | tr '\\' '\n' > "$akhbar_tmp-1"
	pdfurl="$(cat "$akhbar_tmp-1" | grep -m 1 '\.pdf' | sed 's/"/https:/')"
	wget \
	    --no-use-server-timestamps \
	    -O "$filename" -nc -q -t 0 \
	    -- "$pdfurl"
	mv "$filename" "$loc"/"$filename".pdf
	clear-line
	echolor blue ":: ✓  Updated newsletter ““$nlname””: " 1
	echolor red "$dlded ““→”” " 1
	echolor green "$urled"
	echo "$loc"/"$filename".pdf >> "$usdd"/unread-newsletters
    }
}

wifi-connected-p || {
    echolor red ":: Unable to update newsletters, no connection"
    exit
}



zaytouna
kassioun
al-akhbar
