#!/bin/bash
temp_back_what=$(grep '^### ' ~/Repositories/scripts/back/backmaster.sh | tr -d '# ' | sort -r | fzf)

### books
### packages
### wallpapers
### music
### classical

case $temp_back_what in 
			books) ~/Repositories/scripts/back/backbooks.sh ;;
			packages) ~/Repositories/scripts/back/backpacks.sh ;;
			wallpapers) sudo rsync -ruv /usr/share/wallpapers/* ~/Pictures/wallpapers ;;
			music)  ~/Repositories/scripts/back/backmusic.sh ;;
			classical) ~/Repositories/scripts/back/backclassical.sh ;;
			*) echo "Incorrect input" ;;
esac
