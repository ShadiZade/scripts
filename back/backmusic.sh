#!/bin/bash
music_folders="$(ls -1 ~/Music | sed '/classical/d')"
echo -e "\033[33m:: detected "$(echo "$music_folders" | wc -l)" folders\033[0m"
echo ""

while [ -n "$music_folders" ];
do working_folder=$(echo "$music_folders" | sed 1q)
# part 1 of the list-eater "function".
cd ~/Music/"$working_folder" > /dev/null || exit
taffy -- *.mp3 > ~/Misc/Backups/my-music/txt/"$working_folder".txt 2>/dev/null && echo -e ":: \033[32m$working_folder\033[0m done!"
if [ -n "$(ls -l "$(pwd)" | grep '^d')" ];
 then
 subfolder_folders="$(ls -1d "$(pwd)"/*/ | sed 's|/$||g' | awk -F '/' '{print $NF}')"
 while [ -n "$subfolder_folders" ];
 do working_subfolder=$(echo "$subfolder_folders" | sed 1q)
 cd ~/Music/"$working_folder"/"$working_subfolder" > /dev/null || exit
 taffy -- *.mp3 > ~/Misc/Backups/my-music/txt/"$working_folder"-"$working_subfolder".txt 2>/dev/null\
 && echo -e ":: \033[32m$working_folder/$working_subfolder\033[0m done!"
 subfolder_folders=$(echo "$subfolder_folders" | tail -n +2 )
 cd .. > /dev/null || exit
 done
fi
music_folders=$(echo "$music_folders" | tail -n +2 )
# part 2 of the list-eater "function". 
cd .. > /dev/null || exit
done

# convert to titles
cd ~/Misc/Backups/my-music/txt || exit
all_txt="$(ls -1 * | sed 's|.txt||g' | awk -F '-' '{print $1}' | uniq)"
while [ -n "$all_txt" ];
do working_txt=$(echo "$all_txt" | sed 1q)
cat $working_txt* | grep title | awk -F ':' '{print $2}' | sed 's|^[[:space:]]*||g' | sed '/^$/d' | sort > ../titles/"$working_txt"-titles.txt
all_txt=$(echo "$all_txt" | tail -n +2 )
done
echo ""
echo -e "\033[33m:: titles extracted!\033[0m"
echo -e "\033[33m:: all done!\033[0m"
bd () {
    date +"%Y-%m-%d %H-%M"
}
echo -e "\033[33m:: committing to git...\033[0m"
cd ~/Misc/Backups/my-music/ || echo -e "\033[31mWARNING: Failure to go to backup directory!\033[0m" || exit
git add . || echo -e "\033[31mWARNING: Failure to add to git!\033[0m" || exit
echo ""
git commit -m "update music $(bd)" 
cd - > /dev/null || echo -e "\033[31mWARNING: Failure to return to previous directory!\033[0m" || exit
echo ""
echo -e "\033[33m:: Done!\033[0m"

# TODO add CSV conversion 
# this garbage script wouldn't look so fucking ugly if it was in common lisp. oh well.



