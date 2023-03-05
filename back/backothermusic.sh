#!/bin/bash

cd ~/Misc/Backups/my-music/othermusic > /dev/null || exit
rm ./*-songs* && echo -e "\033[33m:: Deleted previous back\033[0m"
dir_list="$(exa -1 ~/Music | sed '/classical/d')"
dir_orig_num="$(echo "$dir_list" | wc -l)"
echo -e "\033[33m:: $dir_orig_num directories detected.\033[0m"
echo -e "\033[33m:: Detected $(fd mp3 ~/Music | sed '/classical/d' | wc -l) songs in total.\033[0m"

while [ -n "$dir_list" ];
do
    working_dir=$(echo "$dir_list" | sed 1q)
    working_song_list=$(fd 'mp3$' ~/Music/"$working_dir")
    working_dir_orig_num=$(echo "$working_song_list" | wc -l)
    current_num=0
    echo -e "\033[33m:: Processing songs in directory $working_dir ($working_dir_orig_num songs)\033[0m"
    while [ -n "$working_song_list" ];
    do
	current_num=$((current_num+1))
	working_song=$(echo "$working_song_list" | sed 1q)
	working_metadata=$(taffy "$working_song")
	working_title="$(echo "$working_metadata" | grep 'title:' | awk -F ':' '{print $NF}' | sed 's|^[[:space:]]*||g')"
	working_artist="$(echo "$working_metadata" | grep 'artist:' | awk -F ':' '{print $NF}' | sed 's|^[[:space:]]*||g')"
	echo "$working_title — $working_artist" >> "$working_dir"-songs.txt
	echo "$working_title" >> "$working_dir"-songs-select.txt
	[ -z "$working_artist" ] || working_artist=$(echo " ""$working_artist"" —")
	echo -e ":: \033[33m($current_num/$working_dir_orig_num)\033[0m Processing\033[32m$working_artist\033[0m $working_title"
	working_song_list="$(echo "$working_song_list" | tail -n +2)"
    done
    dir_list="$(echo "$dir_list" | tail -n +2)"
done

echo -e "\033[33m:: titles extracted!\033[0m"
bd () {
    date +"%Y-%m-%d %H-%M"
}
echo -e "\033[33m:: committing to git...\033[0m"
cd ~/Misc/Backups/my-music/ || echo "\033[31mWARNING: Failure to go to backup directory!" || exit
git add . || echo -e "\033[31mWARNING: Failure to add to git!" || exit
git commit -m "update music $(bd)" 
cd - > /dev/null || echo -e "\033[31mWARNING: Failure to return to previous directory!" || exit
echo -e "\033[33m:: Done!\033[0m"
