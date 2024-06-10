#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh
loc="$HOME/Athenaeum/"
ix="$usdd/athenaeum-index.csv"
bkp="$HOME/Misc/Backups/athenaeum/"

function open-book {
    sld_ttl="$(xsv select title "$ix" | tail -n +2 | sort | uniq | fzf)"
    [[ -z "$sld_ttl" ]] && {
	echolor red ":: Nothing selected."
	return
    }
    [[ "$(xsv select title "$ix" | grep -c "$sld_ttl")" -gt 1 ]] && {
	sld_sbttl="$(xsv search -s title "$sld_ttl" "$ix" | xsv select volume,subtitle | tail -n +2 | fzf | xsv select 2 | tr -d '"')"
	sld_fnm="$loc/$(xsv search -s title "$sld_ttl" "$ix" | xsv search -s subtitle "$sld_sbttl" | xsv select filename | sed -n 2p)"
    } || {
	sld_fnm="$loc/$(xsv search -s title "$sld_ttl" "$ix" | xsv select filename | sed -n 2p)"
    }
    zathura "$sld_fnm" 2>/dev/null
}

function backup-index {
    cmp -s "$ix" "$bkp/$(eza -1f "$bkp" | tail -n 1)" || {
	echolor yellow ":: New entries detected. Backing up index..."
	cp -- "$ix" "$bkp"/athenaeum-index-$(date-string).csv
    }
}

backup-index
open-book
