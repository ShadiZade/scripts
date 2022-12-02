#!/bin/bash
temp_back_what=$(grep '^### ' ~/Repositories/scripts/back/backmaster.sh | tr -d '# ' | sort -r | fzf)

### books
### packages
### wallpapers

case $temp_back_what in 
			books) ~/Repositories/scripts/back/backbooks.sh ;;
			packages) ~/Repositories/scripts/back/backpacks.sh ;;
			wallpapers) sudo rsync -ruv /usr/share/wallpapers/* ~/Pictures/wallpapers ;;
			*) echo "Incorrect input" ;;
esac
