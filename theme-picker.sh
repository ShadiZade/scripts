#!/bin/bash

temp_theme_pick=$(cat ~/Repositories/scripts/bspwm-theme.sh | grep '### ' | tr -d '# ' | sort -r | rofi -dmenu)

if [ "$temp_theme_pick" == "" ]; then exit; fi

# change theme in main theme config script
sed -i "s/bspwm_theme=".*"/bspwm_theme="$temp_theme_pick"/g" ~/Repositories/scripts/bspwm-theme.sh 
source ~/Repositories/scripts/bspwm-theme.sh

# change rofi theme
sed -i "s/@theme \"\/usr\/share\/rofi\/themes\/.*.rasi\"/@theme \"\/usr\/share\/rofi\/themes\/"$temp_theme_pick".rasi\"/g" \
~/Repositories/dotfiles/rofi/config.rasi

# change polybar theme
grep $bspwm_theme_primary_color ~/Repositories/dotfiles/polybar/config.ini | awk -F " =" '{print $1}' \
| xargs -I PLACE sed -i "s/maincolor = \${.*}/maincolor = \${colors.PLACE}/g" ~/Repositories/dotfiles/polybar/config.ini

grep $bspwm_theme_secondary_color ~/Repositories/dotfiles/polybar/config.ini | awk -F " =" '{print $1}' \
| xargs -I PLACE sed -i "s/2ndarycolor = \${.*}/2ndarycolor = \${colors.PLACE}/g" ~/Repositories/dotfiles/polybar/config.ini

grep $bspwm_theme_dark_color ~/Repositories/dotfiles/polybar/config.ini | awk -F " =" '{print $1}' \
| xargs -I PLACE sed -i "s/darkcolor = \${.*}/darkcolor = \${colors.PLACE}/g" ~/Repositories/dotfiles/polybar/config.ini

grep $bspwm_theme_alert_color ~/Repositories/dotfiles/polybar/config.ini | awk -F " =" '{print $1}' \
| xargs -I PLACE sed -i "s/alertcolor = \${.*}/alertcolor = \${colors.PLACE}/g" ~/Repositories/dotfiles/polybar/config.ini

# change dunst theme
sed -i "s/nd = \".*\" #normal-background-color/nd = \"#$bspwm_theme_primary_color\" #normal-background-color/g" \
~/Repositories/dotfiles/dunst/dunstrc

sed -i "s/nd = \".*\" #normal-foreground-color/nd = \"#$bspwm_theme_secondary_color\" #normal-foreground-color/g" \
~/Repositories/dotfiles/dunst/dunstrc

sed -i "s/frame_color = \".*\"/frame_color = \"#$bspwm_theme_secondary_color\"/g" \
~/Repositories/dotfiles/dunst/dunstrc

pkill dunst
# restart wm
bspc wm -r
notify-send -t 2000 "Theme Picker" "Theme changed to $temp_theme_pick"
