#!/bin/bash
source ~/Repositories/scripts/essential-functions

echolor yellow ":: Backing Arch packages..."
pacman -Qeqn > ~/Repositories/dotfiles/arch-packages.txt \
    && echolor blue "\t\t → Done!"

echolor yellow ":: Backing AUR packages..."
pacman -Qeqm > ~/Repositories/dotfiles/aur-packages.txt \
    && echolor blue "\t\t → Done!"

echolor yellow ":: Backing fonts..."
fc-list > ~/Repositories/dotfiles/fonts.txt
rsync -qaru /usr/share/fonts/TTF/ ~/Misc/Backups/fonts \
    && echolor blue "\t\t → Done!"

echolor yellow ":: Backing diary..."
echolor yellow "$(basic-commit ~/Misc/diary/)" \
    && echolor blue "\t\t → Done!"

echolor yellow ":: Backing logs..."
rsync -qaru ~/.local/logs/* ~/Misc/Backups/logs/
echolor yellow "$(basic-commit ~/Misc/Backups/logs/)" \
    && echolor blue "\t\t → Done!"

echolor yellow ":: Backing user script data..."
rsync -qarul ~/.local/share/user-scripts/* ~/Misc/Backups/user-script-data/
echolor yellow "$(basic-commit ~/Misc/Backups/user-script-data/)" \
    && echolor blue "\t\t → Done!"

echolor yellow ":: Backing user bins..."
rsync -qaruL ~/.local/bin/* ~/Misc/Backups/local-bins/
echolor yellow "$(basic-commit ~/Misc/Backups/local-bins/)" \
    && echolor blue "\t\t → Done!"

echolor yellow ":: Backing Buku bookmarks..."
rsync -qaru ~/.local/share/buku/bookmarks.db ~/Misc/Backups/bookmarks/buku
echolor yellow "$(basic-commit ~/Misc/Backups/bookmarks/buku/)" \
    && echolor blue "\t\t → Done!"
