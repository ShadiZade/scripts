#!/bin/bash

[[ $UID != 0 ]] && echo "Please run this script with sudo." && exit
case $which in
		"script")	micro /home/oak/Repositories/scripts/"$1".sh; chmod +x-w /home/oak/Repositories/scripts/"$1".sh 
		;;	 
		"solution") micro /home/oak/Misc/solutions/"$1".txt
		;;
		"polybar-module")	micro /home/oak/Repositories/dotfiles/polybar/"$1".sh; chmod +x-w /home/oak/Repositories/dotfiles/polybar/"$1".sh
		;;	 
		*)	echo ":: Incorrect input"; exit 
		;;
esac 
