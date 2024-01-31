#!/bin/bash

lang=$(eza -1D ~/Repositories/dotfiles/rofimoji/used-files/languages | rofi -dmenu)
[ -z "$lang" ] && exit
rofimoji -a copy --files ~/Repositories/dotfiles/rofimoji/used-files/languages/"$lang"/*  
