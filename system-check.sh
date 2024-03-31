#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh

logdir="$HOME/.local/logs/system-check"
checktime=$(formatted-date-string)

function process-exists {
    echolor white-green ":: ““[CHECK]”” process ““$1”” exists."
}

function process-missing {
    echolor white-red ":: ““[ERROR]”” process ““$1”” does NOT exist."    
}

function process-check {
    pidof -qx "$1" \
	&& process-exists "$1" \
	    || process-missing "$1"
}

process-check "battery-warner.sh"
