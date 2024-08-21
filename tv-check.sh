#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh
tv="$HOME/TV/"

IFS=$'\n'
sl=($(fd -t l . "$tv"))
for j in ${sl[@]}
do
    [[ -e "$j" ]] && continue
    show="$(realpath -ms "$j" | awk -F '/TV/' '{print $2}' | awk -F '/' '{print $1}')"
    remove_p='y'
    echolor yellow-purple ":: Episode ““$j”” in show ““$show”” is broken. Remove? (Y/n) " 1
    read -r remove_p
    [[ "$remove_p" = "n" ]] && continue
    rm -f "$j" || echolor red ":: Failed to remove ““$j””."
    echo "$j was removed on $(date +"%Y-%m-%d %H:%M")" >> "$tv/$show/.record.log"
done
unset IFS
