#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh 

mobiledir="$HOME/.local/mobile/Internal shared storage"
mobilecache="$HOME/.local/share/backmobile/"
lastback="$(cat $mobilecache/times | tail -n 1)"
i=1

function bd {
    [[ "$1" = "short" ]] \
	&& date +"%Y%m%d%H%M%S" \
	    || date +"%Y-%m-%d %H:%M:%S"
}

function back-from-dir {
    [[ -z "$1" ]] \
	&& {
	echolor red ":: !  No directory entered."
	return
    }
    dir="$mobiledir/$1"
    cor_dir="$(cat "$mobilecache"/dirs | grep "^$1," | ifne xsv select 2)"
    echolor green "\n:: This is operation ““$i”” "
    [[ -d "$dir" ]] \
	|| {
	echolor red ":: !  No such directory as ““$dir”” exists."
	return
    }    
    echolor yellow ":: ✓  Source is ““$dir””"
    [[ -z "$cor_dir" ]] \
	&& {
	echolor red ":: !  Destination for ““$1”” not found in definitions file."
	return
    }
    [[ -d "$cor_dir" ]] \
	|| {
	echolor red ":: !  No such directory as ““$cor_dir”” exists."
	return
	}
    echolor yellow ":: ✓  Destination is ““$cor_dir””"
    IFS=$'\n'
    files=($(fd -a --newer "$lastback" . "$dir" | sort -V))
    [[ -z ${files[@]} ]] \
	&& {
	echolor red ":: !  No files found in ““$1””"
	return
    }
    rsync --log-file="$mobilecache"/.transfer-log -Paru "${files[@]}" "$cor_dir"
    ((i++))
}

function back-all {
    IFS=$'\n'
    all_dirs=($(cat "$mobilecache"/dirs | xsv select 1))
    echolor yellow ":: The following directories in mobile will be backed."
    for k in ${all_dirs[@]}
    do
	echolor white "$k"
    done
    echo -ne "\033[33m:: Proceed? (y/N) "
    read -r proceed
    [[ "$proceed" = "y" ]] \
	|| {
	echolor yellow ":: Nothing done."
	return
	}
    for k in ${all_dirs[@]}
    do
	back-from-dir "$k"
    done
}

echolor yellow ":: The latest backup occurred on ““$lastback””"
case "$1" in
    "all") back-all ;;
    "dir") back-from-dir "$2" ;;
    *) echolor red ":: Unknown command." ;;
esac
bd >> "$mobilecache"/times
