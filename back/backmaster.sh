#!/bin/bash
temp_back_what=$(grep '^### ' ~/Repositories/scripts/back/backmaster.sh | tr -d '# ' | fzf)

### packages
### music
### classical
### phone

case $temp_back_what in 
    packages) ~/Repositories/scripts/back/backpacks.sh ;;
    music)  ~/Repositories/scripts/back/backmusic.sh ;;
    classical) ~/Repositories/scripts/back/backclassical.sh ;;
    phone) ~/Repositories/scripts/back/backphone.sh -a ;;
    *) : ;;
esac
