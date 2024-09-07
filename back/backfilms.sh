#!/bin/bash 
source ~/Repositories/scripts/essential-functions.sh

~/Repositories/scripts/donefiler.sh
eza -1 ~/Films > ~/Misc/Backups/video/movies.txt
eza -1 ~/TV > ~/Misc/Backups/video/tv.txt
eza --tree ~/Films > ~/Misc/Backups/video/tree-movies.txt
eza --tree ~/TV > ~/Misc/Backups/video/tree-tv.txt
echolor yellow ":: Films and TV backed successfully!"
basic-commit ~/Misc/Backups/video/
echolor yellow ":: Done!"

