#!/bin/bash
source ~/Repositories/scripts/essential-functions

cd ~/Misc/Backups/my-music/classical > /dev/null \
    || exit
rm ./*-works.txt \
    && echolor yellow ":: Deleted previous back"
IFS=$'\n'
piece_list=($(fd 'mp3$' ~/Music/classical))
echolor yellow ":: ““${#piece_list[@]}”” pieces detected."
i=0
for j in ${piece_list[@]}
do
    ((i++))
    working_metadata="$(tagutil -F json -- "$j")"
    working_title="$(echo "$working_metadata" | jq -r '.[0].title')"
    working_artist="$(echo "$working_metadata" | jq -r '.[1].artist')"
    [ -z "$working_artist" ] && working_artist="Unknown"
    echo -e ":: \033[33m($i/${#piece_list[@]})\033[0m Processing \033[32m$working_artist\033[0m’s $working_title"
    echo "$working_title" >> "$working_artist"-works.txt
done
echolor yellow ":: Titles extracted!"
rsync -Paru "$HOME"/.config/quodlibet/playlists/* "$HOME"/Misc/Backups/my-music/playlists \
    && echolor yellow ":: Updated playlists..."
echolor yellow ":: committing to git..."
basic-commit ~/Misc/Backups/my-music/

