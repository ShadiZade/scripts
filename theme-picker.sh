#!/bin/bash

temp_theme_pick=$(cat ~/Repositories/scripts/bspwm-theme.sh | grep '### ' | tr -d '# ' | fzf)

sed -i "s/bspwm_theme=".*"/bspwm_theme="$temp_theme_pick"/g" ~/Repositories/scripts/bspwm-theme.sh 


bspc wm -r

