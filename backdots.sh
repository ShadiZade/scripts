#!/bin/bash

bd () {
    date +"%Y%m%d%H%M"
}


# Copy entire polybar folder
cp -r ~/.config/polybar ~/Misc/Backups/polybar
cd ~/Misc/Backups/polybar/polybar
for i in *; do mv "$i" "$i"-backup-$(bd); done
cd ..
mv ~/Misc/Backups/polybar/polybar ~/Misc/Backups/polybar/polybar-configs-backup-$(bd)
###


# Copy entire .scripts folder
cp -r ~/.scripts ~/Misc/Backups/scripts
cd ~/Misc/Backups/scripts/.scripts
for i in *; do mv "$i" "$i"-backup-$(bd); done
cd ..
mv ~/Misc/Backups/scripts/.scripts ~/Misc/Backups/scripts/scripts-backup-$(bd)
###


cp ~/.config/zsh/.zshrc ~/Misc/Backups/zshrc/zshrc-backup-$(bd)
cp ~/.config/emacs/init.el ~/Misc/Backups/emacs-init/init.el-backup-$(bd)
cp ~/.config/awesome/rc.lua ~/Misc/Backups/awesome/rc-lua/rc.lua-backup-$(bd)
cp ~/.config/awesome/theme.lua ~/Misc/Backups/awesome/theme-lua/theme.lua-backup-$(bd)
cp ~/.config/bspwm/bspwmrc ~/Misc/Backups/bspwm/bspwmrc-backup-$(bd)
cp ~/.config/sxhkd/sxhkdrc ~/Misc/Backups/sxhkd/sxhkdrc-backup-$(bd)
cp ~/.config/kitty/kitty-awesome.conf ~/Misc/Backups/kitty/awesome/kitty-awesome.conf-backup-$(bd)
cp ~/.config/kitty/kitty-bspwm.conf ~/Misc/Backups/kitty/bspwm/kitty-bspwm.conf-backup-$(bd)
pacman -Qeqn > ~/Misc/Backups/programs/official/official-pacman-backup-$(bd)
pacman -Qeqm > ~/Misc/Backups/programs/aur/aur-pacman-backup-$(bd)
