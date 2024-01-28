#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh

echolor yellow ":: Backing Arch packages..."
pacman -Qeqn > ~/Repositories/dotfiles/arch-packages.txt \
    && echolor blue "\t\t → Done!"

echolor yellow ":: Backing AUR packages..."
pacman -Qeqm > ~/Repositories/dotfiles/aur-packages.txt \
    && echolor blue "\t\t → Done!"

echolor yellow ":: Backing fonts..."
fc-list > ~/Repositories/dotfiles/fonts.txt \
    && echolor blue "\t\t → Done!"

echolor yellow ":: Backing diary..."
echolor yellow "$(basic-commit ~/Misc/diary/)" \
    && echolor blue "\t\t → Done!"
