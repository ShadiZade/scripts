#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh

IFS=$'\n'
file_list=($(eza -1 --no-quotes .))
for j in ${file_list[@]}
do
    ~/Repositories/scripts/mv-kebab.sh "$j"
done

	
