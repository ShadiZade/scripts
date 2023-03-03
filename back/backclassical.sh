#!/bin/bash

cd ~/Misc/Backups/my-music/classical > /dev/null || exit
rm ./*-works.txt && echo -e "\033[31m:: Deleted previous back\033[0m"
piece_list=$(fd ".mp3" ~/Music/classical)
orig_num="$(echo "$piece_list" | wc -l)"
echo -e "\033[31m:: $orig_num pieces detected.\033[0m"
current_num=0

while [ -n "$piece_list" ];
do
    current_num=$((current_num+1))
    working_piece="$(echo "$piece_list" | sed 1q)"
    working_metadata="$(taffy "$working_piece")"
    working_title="$(echo "$working_metadata" | grep title | awk -F ':' '{print $NF}' | sed 's|^[[:space:]]*||g')"
    echo -e ":: \033[33m($current_num/$orig_num)\033[0m Processing $working_title"
    working_artist="$(echo "$working_metadata" | grep artist | awk -F ':' '{print $NF}' | sed 's|^[[:space:]]*||g')"
    [ -z "$working_artist" ] && working_artist="Unknown"
    echo "$working_title" >> "$working_artist"-works.txt
    piece_list="$(echo "$piece_list" | tail -n +2)"
done

echo ""
echo ":: titles extracted!"
echo ":: all done!"
bd () {
    date +"%Y-%m-%d %H-%M"
}
echo ":: committing to git..."
cd ~/Misc/Backups/my-music/ || echo "\033[31mWARNING: Failure to go to backup directory!" || exit
git add . || echo "\033[31mWARNING: Failure to add to git!" || exit
echo ""
git commit -m "update music $(bd)" 
cd - > /dev/null || echo "\033[31mWARNING: Failure to return to previous directory!" || exit
echo ""
echo ":: Done!"
