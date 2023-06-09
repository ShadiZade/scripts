#!/bin/zsh

donemovies=($(fd donefile ~/Movies | awk -F '/' '{print $5}' | sed 's/\n/ /g'))
i=$(echo ${#donemovies})
[ "$i" -eq 0 ] && exit
while [ "$i" -gt 0 ]; do
    echo -e ":: \033[33m${donemovies[$i]}\033[0m is a finished movie"
    mv "$(ls -1 $HOME/Movies/${donemovies[$i]}/donefile*)" ~/Misc/Backups/movies-and-tv/donefiles/ && echo -e "\033[32m:: Moved donefile of ${donemovies[$i]} to backup\033[0m"
    rm -vir "$HOME/Movies/${donemovies[$i]}"
    i=$((i-1))
done
cd ~/Misc/Backups/movies-and-tv || exit
git add *
git commit -m "commit $(date +"%Y-%m-%d %H:%M")"
cd -
