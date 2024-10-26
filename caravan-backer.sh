#!/bin/bash
source $HOME/Repositories/scripts/essential-functions.sh

echolor purple "::::::::    CARAVAN•••BACKER   :::::::::"
echolor purple "::::::::" 1
echolor green-yellow "    PUTTING ““THE”” " 1
echolor orange "CART   " 1
echolor purple "::::::::"
echolor purple "::::::::" 1
echolor aquamarine "    BEFORE " 1
echolor bloody-pink "THE ““HORSE””   " 1
echolor purple "::::::::"
echolor purple "::::::::" 1
echolor lightorange-default "    EVERYDAY““!!!!!!!!””   " 1
echolor purple "::::::::"
[[ ! -e "/dev/mapper/caravan" ]] && {
    echolor red ":: No hard drive found."
    exit
}

function mount-with-opts {
    sudo mount -o noatime,compress=zstd,space_cache=v2 /dev/mapper/caravan /mnt || {
	echolor red ":: Failed to mount!"
	exit
    }
}

! mountpoint -q /mnt && mount-with-opts

cur_date=
logfile="$HOME/.local/logs/caravan/caravan-backer-$(date-string).log"
touch "$logfile"
IFS=$'\n'
for j in $(cat $HOME/.local/share/user-scripts/caravan-destinations)
do
    orig="$HOME/$(echo "$j" | xsv select -n 1)"
    dest="$(echo "$j" | xsv select -n 2)"
    echolor orange-purple ":: From ““$orig”” to ““$dest””"
    [[ "$orig" = "$HOME/" ]] && {
	echolor red ":: Origin (““$orig””) is incorrect!"
	exit 1
    }
    [[ ! -e "$dest" ]] && {
	echolor red ":: Destination (““$dest””) is incorrect!"
	exit 1
    }
    sudo rsync -PparulXv --delete --log-file="$logfile" "$orig"/* "$dest"
done
