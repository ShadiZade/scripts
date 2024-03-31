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
    pidof -qx "$1" && {
	process-exists "$1"
	echo "$checktime,CHECK,$1,$(pidof -x "$1")" >> "$logdir"/system-check-"$logtime".log
    } || {
	process-missing "$1"
	echo "$checktime,ERROR,$1,NOPID" >> "$logdir"/system-check-"$logtime".log
    }
}

process-check "battery-warner.sh"
