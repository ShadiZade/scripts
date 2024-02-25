#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh

lang=$(eza -1f ~/Repositories/dotfiles/rofimoji/used-files/languages | sed 's/\.csv//g' | rofi -dmenu)
[ -z "$lang" ] && exit
rofimoji -a copy --files ~/Repositories/dotfiles/rofimoji/used-files/languages/"$lang".csv
