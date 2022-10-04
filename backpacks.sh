#!/bin/bash
pacman -Qeqn > ~/Repositories/dotfiles/arch-packages.txt
pacman -Qeqm > ~/Repositories/dotfiles/aur-packages.txt
