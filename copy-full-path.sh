#!/bin/bash 

if [ "$1" == "." ]; then
	pwd | xclip -selection clipboard
	exit
fi

echo "$(pwd)/$(ls -1 | grep $1)" | xclip -selection clipboard
