#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh
[[ -z "$usdd" ]] && return 1
fwf="$usdd/frequent-words"
[[ ! -e "$fwf" ]] && return 1

function output-slot {
    IFS=$'\n'
    contents=($(cat "$fwf" | sed 's/^$/EMPTYSLOT/g'))
    echo {1..9} | grep -q "$1" || return 1
    echo ' ' | grep -q "$1" && return 1
    # pia = position in array
    pia=$(($1-1))
    echo "${contents[$pia]}" | sed 's/EMPTYSLOT//g' | tr -d '\n'
    unset IFS
}

function copy-slot {
    output-slot "$1" | xclip -selection clipboard
}

function mod-slot {
    # $1 is slot number {1..9}, $2 is content to write to slot
    # leave $2 empty for clearing the slot
    # "EMPTYSLOT" is illegal $2 input
    IFS=$'\n'
    contents=($(cat "$fwf" | sed 's/^$/EMPTYSLOT/g'))
    echo {1..9} | grep -q "$1" || return 1
    echo ' ' | grep -q "$1" && return 1
    [[ "$2" = "EMPTYSLOT" ]] && return 1
    newcontent="$(echo "$2" | tr -d '\n')"
    # pia = position in array
    pia=$(($1-1))
    for j in {0..8}
    do
	[[ "$j" -ne "$pia" ]] && {
	    [[ "${contents[$j]}" = "EMPTYSLOT" ]] && {
	 	echo >> "$fwf"-temp
	    } || {
		echo "${contents[$j]}" >> "$fwf"-temp
	    }
	}
	[[ "$j" -eq "$pia" ]] && {
	    echo "$newcontent" >> "$fwf"-temp
	}
    done
    mv -f "$fwf"-temp "$fwf"
    unset IFS
}

function view-slots {
    cat "$fwf"                                    \
	| nl -ba -s ' '                           \
	| sed 's/^ *//g'                          \
	| rofi -normalize-match -dmenu -i         \
	| cut -c3-                                \
	| tr -d '\n'                              \
	| xclip -selection clipboard
}

function clear-slots {
    for j in {1..9}
    do
	mod-slot "$j"
    done
}

case "$1" in
    "view") view-slots ;;
    "out") output-slot "$2" ;;
    "copy") copy-slot "$2" ;;
    "clear") clear-slots ;;
    "mod") mod-slot "$2" "$3" ;;
    '') view-slots ;;
    *) echolor red ":: Unknown command"
       exit 1 ;;
esac
    
