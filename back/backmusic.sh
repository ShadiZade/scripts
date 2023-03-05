#!/bin/bash
music_folders="$(ls -1 ~/Music | sed '/classical/d')"
echo :: detected "$(echo "$music_folders" | wc -l)" folders
echo ""

while [ -n "$music_folders" ];
do working_folder=$(echo "$music_folders" | sed 1q)
# part 1 of the list-eater "function".
cd ~/Music/"$working_folder" > /dev/null || exit
taffy -- *.mp3 > ~/Misc/Backups/my-music/txt/"$working_folder".txt 2>/dev/null && echo ":: $working_folder done!"
if [ -n "$(ls -l "$(pwd)" | grep '^d')" ];
 then
 subfolder_folders="$(ls -1d "$(pwd)"/*/ | sed 's|/$||g' | awk -F '/' '{print $NF}')"
 while [ -n "$subfolder_folders" ];
 do working_subfolder=$(echo "$subfolder_folders" | sed 1q)
 cd ~/Music/"$working_folder"/"$working_subfolder" > /dev/null || exit
 taffy -- *.mp3 > ~/Misc/Backups/my-music/txt/"$working_folder"-"$working_subfolder".txt 2>/dev/null\
 && echo ":: $working_folder/$working_subfolder done!"
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

# TODO add CSV conversion 
# this garbage script wouldn't look so fucking ugly if it was in common lisp. oh well.



