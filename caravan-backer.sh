#!/bin/bash
source $HOME/Repositories/scripts/essential-functions

[[ -z "$1" ]] && {
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
    echolor liteorange-default "    EVERYDAY““!!!!!!!!””   " 1
    echolor purple "::::::::"
} || {
    echolor red "::::::::    CARAVAN•••BACKER   :::::::::"
    echolor red "::::::::    DRYRUN    DRYRUN   :::::::::"
    echolor red "::::::::    DRYRUN    DRYRUN   :::::::::"
    echolor red "::::::::    DRYRUN    DRYRUN   :::::::::"
    echolor red "::::::::    DRYRUN    DRYRUN   :::::::::"
    echolor red "::::::::    DRYRUN    DRYRUN   :::::::::"
}
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
    case "$1" in
	"dry")
	    dryfile="$HOME/.local/logs/caravan/caravan-backer-dry-$(date-string).log"
	    touch "$dryfile"
	    sudo rsync                                                             \
		 -PparulXvhn                                                       \
		 --delete                                                          \
		 --out-format='%o ——— %n%L'                                        \
		 --log-file="$dryfile"                                             \
		 --exclude-from="$HOME/.local/share/user-scripts/caravan-exclude"  \
		 "$orig"/                                                          \
		 "$dest"/
	    ;;
	"")
	    logfile="$HOME/.local/logs/caravan/caravan-backer-$(date-string).log"
	    touch "$logfile"
	    sudo rsync                                                             \
		 -PparulXvh                                                        \
		 --delete                                                          \
		 --out-format='%o ——— %n%L'                                        \
		 --log-file="$logfile"                                             \
		 --exclude-from="$HOME/.local/share/user-scripts/caravan-exclude"  \
		 "$orig"/                                                          \
		 "$dest"/
	    ;;
	*)
	    echolor red ":: Unrecognized command"
	    ;;
    esac
done
unset IFS
