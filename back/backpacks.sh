#!/bin/bash
source ~/Repositories/scripts/essential-functions
echolor ←yellow ":: Backing packages..."
pacman -Qeqn > ~/Repositories/dotfiles/arch-packages.txt
pacman -Qeqm > ~/Repositories/dotfiles/aur-packages.txt
pipx list | grep '^   package' | awk '{print $2}' > ~/Repositories/dotfiles/pipx-packages.txt
echolor blue "\t\t → Done!"

echolor ←yellow ":: Backing fonts..."
fc-list > ~/Repositories/dotfiles/fonts.txt
rsync -qaru /usr/share/fonts/TTF/ ~/Misc/Backups/fonts
echolor blue "\t\t → Done!"

echolor ←yellow ":: Backing diary..."
echolor yellow "$(basic-commit ~/Misc/diary/)"
echolor blue "\t\t → Done!"

echolor ←yellow ":: Backing logs..."
rsync -qaru ~/.local/logs/* ~/Misc/Backups/logs/
echolor yellow "$(basic-commit ~/Misc/Backups/logs/)" 
echolor blue "\t\t → Done!"

echolor ←yellow ":: Backing user script data..."
rsync -qarul ~/.local/share/user-scripts/* ~/Misc/Backups/user-script-data/
echolor yellow "$(basic-commit ~/Misc/Backups/user-script-data/)"
echolor blue "\t\t → Done!"

echolor ←yellow ":: Backing local bin and man..."
rsync -qaruL ~/.local/bin/* ~/Misc/Backups/local/
eza --no-quotes --sort=ext --group-directories-first --tree --color never ~/.local/bin/ > ~/Misc/Backups/local/bin-tree.txt
eza --no-quotes --sort=ext --group-directories-first --tree --color never ~/.local/share/man/ > ~/Misc/Backups/local/man-tree.txt
echolor yellow "$(mandb -u)"
echolor yellow "$(basic-commit ~/Misc/Backups/local/)"
echolor blue "\t\t → Done!"

echolor ←yellow ":: Backing Buku bookmarks..."
rsync -qaru ~/.local/share/buku/bookmarks.db ~/Misc/Backups/bookmarks/buku
echolor yellow "$(basic-commit ~/Misc/Backups/bookmarks/buku/)"
echolor blue "\t\t → Done!"

echolor ←yellow ":: Backing media history..."
eza --tree -a ~/Aquire/ > ~/Misc/Backups/video/tree-aquire.txt
eza -1 ~/Films > ~/Misc/Backups/video/movies.txt
eza -1 ~/TV > ~/Misc/Backups/video/tv.txt
eza --tree ~/Films > ~/Misc/Backups/video/tree-film.txt
eza --tree ~/TV > ~/Misc/Backups/video/tree-tv.txt
eza --tree ~/Excluding/youtube/ > ~/Misc/Backups/video/tree-youtube.txt
eza --tree ~/Excluding/documentaries/ > ~/Misc/Backups/video/tree-youtube.txt
rsync -qaru ~/Excluding/youtube/.rules.hezi /home/shadi/Misc/Backups/video/rules.hezi
echolor yellow "$(basic-commit ~/Misc/Backups/video)" 
echolor blue "\t\t → Done!"

echolor ←yellow ":: Backing torrents..."
rsync -qaru ~/.config/qBittorrent/categories.json ~/Misc/Backups/qbittorrent/
rsync -qaru ~/.config/qBittorrent/qBittorrent.conf ~/Misc/Backups/qbittorrent/
eza --tree -a ~/P2P > ~/Misc/Backups/qbittorrent/tree-torrent.txt
echolor yellow "$(basic-commit ~/Misc/Backups/qbittorrent/)" 
echolor blue "\t\t → Done!"

echolor ←yellow ":: Backing FreeTube..."
rsync -qaru ~/.config/FreeTube/*db /home/shadi/Misc/Backups/freetube
echolor yellow "$(basic-commit ~/Misc/Backups/freetube/)" 
echolor blue "\t\t → Done!"

echolor ←yellow ":: Backing notes..."
echolor yellow "$(basic-commit ~/Notes/)" 
echolor blue "\t\t → Done!"

echolor ←yellow ":: Backing RSS..."
mkdir -p ~/Misc/Backups/rss/
rsync -qaru ~/.local/share/user-scripts/elfeed-feeds.el ~/Misc/Backups/rss/
rsync -qaru ~/.config/emacs/elfeed/* ~/Misc/Backups/rss/
echolor yellow "$(basic-commit ~/Misc/Backups/rss/)" 
echolor blue "\t\t → Done!"

echolor ←yellow ":: Backing document data..."
rsync -qaru ~/.local/share/sioyek/last_document_path.txt ~/Projects/reading/.data/
rsync -qaru ~/Documents/papers/refs.bib ~/Projects/reading/.data/misc-academic-papers.bib
echolor yellow "$(basic-commit ~/Projects/reading/.data/)" 
echolor blue "\t\t → Done!"

