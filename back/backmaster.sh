#!/bin/bash
temp_back_what=$(grep '^### ' ~/Repositories/scripts/back/backmaster.sh | tr -d '# ' | sort -r | fzf)

### books
### packages
### music
### classical
### mobile

case $temp_back_what in 
    books) ~/Repositories/scripts/back/backbooks.sh ;;
    packages) ~/Repositories/scripts/back/backpacks.sh ;;
    music)  ~/Repositories/scripts/back/backmusic.sh ;;
    classical) ~/Repositories/scripts/back/backclassical.sh ;;
    mobile) ~/Repositories/scripts/back/backmobile.sh -a ;;
    *) echo "Incorrect input" ;;
esac
