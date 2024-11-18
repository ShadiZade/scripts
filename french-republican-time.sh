#!/bin/bash
source ~/Repositories/scripts/essential-functions

rural="$HOME/.local/share/user-scripts/rural-cal"
command -v repcal >/dev/null || {
    echo -n
    exit
    # https://github.com/dekadans/repcal
}
datestring="$(repcal -f '{%+A}, {%d} {%+B} ({%m}) an {%Y},')"
ruralname="$(grep "$(repcal -f '{%+B} {%d}')|" "$rural" | awk -F "|" '{print $3,"("$NF")"}')"
echo "$datestring $ruralname"
