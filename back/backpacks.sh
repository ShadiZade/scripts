#!/bin/bash
echo ":: Backing packages..."
pacman -Qeqn > ~/Repositories/dotfiles/arch-packages.txt && echo ":: Arch packages backed successfully!"
pacman -Qeqm > ~/Repositories/dotfiles/aur-packages.txt && echo ":: AUR packages backed successfully!"
fc-list > ~/Repositories/dotfiles/fonts.txt && echo ":: Fonts backed successfully!"
