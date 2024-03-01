#!/bin/zsh
source ~/Repositories/scripts/essential-functions.sh 

IFS=$'\n'
donemovies=($(fd donefile ~/Movies | awk -F '/' '{print $5}' | sed 's/\n/ /g'))
[[ "${#donemovies[@]}" -eq 0 ]] \
    && \
    {
	echolor yellow ":: No finished movies."
	exit
    }
for j in ${donemovies[@]}
do
    echo -ne ":: \033[33m$j\033[0m is a finished movie. Delete? (y/N) "
    read -r delete_p
    [[ "$delete_p" != "y" ]] \
	&& \
	{
	    echolor yellow-white ":: Doing nothing to ““$j””."
	    continue
	}
    mv "$(eza -1f $HOME/Movies/$j/donefile*)" ~/Misc/Backups/video/donefiles/ \
	&& echolor yellow ":: Moved donefile of ““$j”” to backup" \
	    || \
	    {
		echolor red ":: Error moving donefile! Exiting..."
		exit
	    }
    move-to-trash-recursively "$HOME/Movies/$j"
done
