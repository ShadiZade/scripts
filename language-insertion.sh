#!/bin/bash

lang=$(echo -e "arabic\nspanish\nportuguese\nenglish\nitalian\ngerman\nturkish" | rofi -dmenu)
[ -z "$lang" ] && exit
rofimoji --files ~/Repositories/dotfiles/rofimoji/used-files/languages/"$lang"/*  
