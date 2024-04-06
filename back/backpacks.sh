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

echolor yellow ":: Backing logs..."
rsync -qaru ~/.local/logs/* ~/Misc/Backups/logs/
echolor yellow "$(basic-commit ~/Misc/Backups/logs/)" \
    && echolor blue "\t\t → Done!"

echolor yellow ":: Backing user script data..."
rsync -qaru ~/.local/share/user-scripts/* ~/Misc/Backups/user-script-data/
echolor yellow "$(basic-commit ~/Misc/Backups/user-script-data/)" \
    && echolor blue "\t\t → Done!"

