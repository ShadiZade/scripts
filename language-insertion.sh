#!/bin/bash

lang=$(echo -e "spanish\nenglish\nitalian\ngerman" | rofi -dmenu)
[ -z "$lang" ] && exit
rofimoji --files ~/Repositories/dotfiles/rofimoji/used-files/languages/"$lang"/*  
