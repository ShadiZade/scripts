#!/bin/bash

 if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo."
    exit 1
 fi

case $which in

		script)
				 micro /home/oak/Repositories/scripts/"$1".sh; chmod +x /home/oak/Repositories/scripts/"$1".sh 
				 ;;
			 
		solution) 
				micro /home/oak/Misc/solutions/"$1".txt
				;;

		polybar-module)
				micro /home/oak/Repositories/dotfiles/polybar/"$1".sh
				;;
			 
		*)
			 	echo ":: Incorrect input"; exit 
			 	;;
esac 
