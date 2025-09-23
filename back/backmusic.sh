#!/bin/bash
source ~/Repositories/scripts/essential-functions

music_folders=($(eza -1D ~/Music | sed '/classical/d'))
echolor yellow ":: Detected ${#music_folders[@]} folders\n"

for j in ${music_folders[@]};
do
    cd ~/Music/ > /dev/null || exit
    tagutil -- "$j"/*.mp3 "$j"/*.flac > ~/Misc/Backups/my-music/txt/"$j".txt 2>/dev/null
    echolor green-pink ":: ““$j”” done!"
    if [ -n "$(eza --no-quotes -1D "$j")" ];
    then
	music_subfolders=($(eza -1D "$j"))
	for k in ${music_subfolders[@]}
	do
	    tagutil -- "$j"/"$k"/*.mp3 "$j"/"$k"/*.flac > ~/Misc/Backups/my-music/txt/"$j"-"$k".txt 2>/dev/null
	    echolor green-pink ":: ─────── ““$j/$k”” done!"
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
echolor yellow "\n:: Titles extracted!"
rsync -Paru "$HOME"/.config/quodlibet/playlists/* "$HOME"/Misc/Backups/my-music/playlists \
    && echolor yellow ":: Updated playlists..."
echolor yellow ":: Committing to git..."
basic-commit ~/Misc/Backups/my-music/
echolor yellow ":: Done!"

# TODO add CSV conversion 

