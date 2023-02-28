#!/bin/bash

lang=$(echo -e "spanish\nenglish\ngerman" | rofi -dmenu)
[ -z "$lang" ] && exit
rofimoji --files ~/Repositories/dotfiles/rofimoji/used-files/languages/"$lang"/*  
