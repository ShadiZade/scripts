#!/bin/bash

cd ~/Misc/Backups/my-music/classical > /dev/null || exit
rm ./*-works.txt && echo -e "\033[33m:: Deleted previous back\033[0m"
piece_list=$(fd 'mp3$' ~/Music/classical)
orig_num="$(echo "$piece_list" | wc -l)"
echo -e "\033[33m:: $orig_num pieces detected.\033[0m"
current_num=0

while [ -n "$piece_list" ];
do
    current_num=$((current_num+1))
    working_piece="$(echo "$piece_list" | sed 1q)"
    working_metadata="$(taffy "$working_piece")"
    working_title="$(echo "$working_metadata" | grep 'title:' | awk -F ':' '{print $NF}' | sed 's|^[[:space:]]*||g')"
    working_artist="$(echo "$working_metadata" | grep 'artist:' | awk -F ':' '{print $NF}' | sed 's|^[[:space:]]*||g')"
    [ -z "$working_artist" ] && working_artist="Unknown"
    echo -e ":: \033[33m($current_num/$orig_num)\033[0m Processing \033[32m$working_artist\033[0m’s $working_title"
    echo "$working_title" >> "$working_artist"-works.txt
    piece_list="$(echo "$piece_list" | tail -n +2)"
done

echo -e "\033[33m:: titles extracted!\033[0m"
bd () {
    date +"%Y-%m-%d %H-%M"
}
cp -f "$HOME"/.config/quodlibet/playlists/* "$HOME"/Misc/Backups/my-music/playlists && echo -e "\033[33m:: Updated playlists...\033[0m"
echo -e "\033[33m:: committing to git...\033[0m"
cd ~/Misc/Backups/my-music/ || echo "\033[31mWARNING: Failure to go to backup directory!" || exit
git add . || echo -e "\033[31mWARNING: Failure to add to git!" || exit
git commit -m "update music $(bd)" 
cd - > /dev/null || echo -e "\033[31mWARNING: Failure to return to previous directory!" || exit
echo -e "\033[33m:: Done!\033[0m"
