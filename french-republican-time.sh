#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh

rural="$HOME/Repositories/scripts/src/rural-cal"
command -v repcal >/dev/null || {
    echo -n
    exit
    # https://github.com/dekadans/repcal
}
datestring="$(repcal -f '{%+A}, {%d} {%+B} ({%m}) an {%Y},')"
ruralname="$(grep "$(repcal -f '{%+B} {%d}')|" "$rural" | awk -F "|" '{print $3,"("$NF")"}')"
echo "$datestring $ruralname"
