#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh

IFS=$'\n'
file_list=($(eza -1X --no-quotes .))
i=1
m="${#file_list[@]}"
for j in ${file_list[@]}
do
    echolor yellow-aquamarine "(““$(printf '%.3d' "$i")””/$(printf '%.3d' "$m"))" 
    ~/Repositories/scripts/mv-kebab.sh "$j"
    ((i++))
done
unset IFS
