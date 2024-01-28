#!/bin/bash
music_folders=($(eza -1D ~/Music | sed '/classical/d'))
echo -e "\033[33m:: detected ${#music_folders[@]} folders\033[0m"
echo ""

for j in ${music_folders[@]};
do
    cd ~/Music/ > /dev/null \
	|| exit
    taffy -- "$j"/*.mp3 > ~/Misc/Backups/my-music/txt/"$j".txt 2>/dev/null \
	&& echo -e ":: \033[32m$j\033[0m done!"
    if [ -n "$(eza -1D "$j")" ];
    then
	music_subfolders=($(eza -1D "$j"))
	for k in ${music_subfolders[@]}
	do
	    taffy -- "$j"/"$k"/*.mp3 > ~/Misc/Backups/my-music/txt/"$j"-"$k".txt 2>/dev/null \
		&& echo -e ":: ───── \033[32m$j/$k\033[0m done!"
	done
    fi
done

# convert to titles
cd ~/Misc/Backups/my-music/txt \
    || exit
all_txt=($(ls -1 * | sed 's|.txt$||g' | awk -F '-' '{print $1}' | uniq))
for m in ${all_txt[@]}
do
    cat "$m"* \
	| grep title \
	| awk -F ':' '{print $2}' \
	| sed 's/^ *//g;/^$/d' \
	| sort \
	| uniq \
	      > ../titles/"$m"-titles.txt
done
echo ""
echo -e "\033[33m:: titles extracted!\033[0m"
rsync -Paru "$HOME"/.config/quodlibet/playlists/* "$HOME"/Misc/Backups/my-music/playlists \
    && echo -e "\033[33m:: Updated playlists...\033[0m"
echo -e "\033[33m:: committing to git...\033[0m"
cd ~/Misc/Backups/my-music/ \
    || echo -e "\033[31mWARNING: Failure to go to backup directory!\033[0m" || exit
git add . \
    || echo -e "\033[31mWARNING: Failure to add to git!\033[0m" || exit
echo ""
git commit -m "update music $(date +"%Y-%m-%d %H-%M")" 
echo ""
echo -e "\033[33m:: Done!\033[0m"

# TODO add CSV conversion 
# this garbage script wouldn't look so fucking ugly if it was in common lisp. oh well.
# ^^ just learn to use arrays, dumbass


