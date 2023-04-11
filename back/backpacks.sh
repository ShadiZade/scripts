#!/bin/bash
back-movies-tv () {
ls -1 ~/Movies > ~/Misc/Backups/movies-and-tv/movies.txt
ls -1 ~/TV > ~/Misc/Backups/movies-and-tv/tv.txt
exa --tree ~/Movies > ~/Misc/Backups/movies-and-tv/tree-movies.txt
exa --tree ~/TV > ~/Misc/Backups/movies-and-tv/tree-tv.txt
}

pacman -Qeqn > ~/Repositories/dotfiles/arch-packages.txt && echo ":: Arch packages backed successfully!"
pacman -Qeqm > ~/Repositories/dotfiles/aur-packages.txt && echo ":: AUR packages backed successfully!"
fc-list > ~/Repositories/dotfiles/fonts.txt && echo ":: Fonts backed successfully!"
back-movies-tv && echo ":: Movies and TV backed successfully!"

