#!/bin/bash
function back-movies-tv {
    ~/Repositories/scripts/donefiler.sh
    ls -1 ~/Movies > ~/Misc/Backups/video/movies.txt
    ls -1 ~/TV > ~/Misc/Backups/video/tv.txt
    exa --tree ~/Movies > ~/Misc/Backups/video/tree-movies.txt
    exa --tree ~/TV > ~/Misc/Backups/video/tree-tv.txt
}

function back-diary {
    cd ~/Misc/diary/
    git add .
    git commit -m "$(date +"%Y%m%d%H%M")"
    cd -
}

pacman -Qeqn > ~/Repositories/dotfiles/arch-packages.txt && echo ":: Arch packages backed successfully!"
pacman -Qeqm > ~/Repositories/dotfiles/aur-packages.txt && echo ":: AUR packages backed successfully!"
fc-list > ~/Repositories/dotfiles/fonts.txt && echo ":: Fonts backed successfully!"
back-diary && echo ":: Diary backed successfully!"
back-movies-tv && echo ":: Movies and TV backed successfully!"

