#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh

file_list="$(ls -1 .)"
while [ "$file_list" != "" ]
do
    ~/Repositories/scripts/mv-kebab.sh "$(echo "$file_list" | sed 1q)"
    file_list="$(echo "$file_list" | tail -n +2)"
done

	
