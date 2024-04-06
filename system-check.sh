#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh

logdir="$HOME/.local/logs/system-check"
checktime=$(formatted-date-string)
logtime="$(echo -n $checktime | cut -c-8)"

function process-exists {
    echolor white-green ":: ““[CHECK]”” process ““$1”” exists."
}

function process-missing {
    echolor white-red ":: ““[ERROR]”” process ““$1”” does NOT exist."    
}

function process-check {
    [[ -z "$(pgrep --full "$1")" ]] && {
	process-missing "$2"
	echo "$checktime,ERROR,$1,NOPID" >> "$logdir"/system-check-"$logtime".log
    } || {
	process-exists "$2"
	echo "$checktime,CHECK,$1,$(pgrep --full "$1")" >> "$logdir"/system-check-"$logtime".log
    }
}

process-check "battery-warner.sh" "battery warner"
process-check 'emacs --daemon' "emacs daemon"
