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
    [[ -z "$1" ]] && {
	echolor red ":: !  No directory entered."
	return
    }
    dir="$mobiledir/$1"
    cor_dir="$(cat "$mobilecache"/dirs | grep "^$1," | ifne xsv select 2)"
    echolor green "\n:: This is operation ““$i”” "
    ((i++))
    [[ -d "$dir" ]] || {
	echolor red ":: !  No such directory as ““$dir”” exists."
	return
    }    
    echolor yellow ":: ✓  Source is ““$dir””"
    [[ -z "$cor_dir" ]] && {
	echolor red ":: !  Destination for ““$1”” not found in definitions file."
	return
    }
    [[ -d "$cor_dir" ]] || {
	echolor red ":: !  No such directory as ““$cor_dir”” exists."
	return
	}
    echolor yellow ":: ✓  Destination is ““$cor_dir””"
    [[ "$(eza -1 "$dir" | wc -l)" -eq 0 ]] && {
	echolor red ":: !  No files found in ““$1””"
	return
    }
    IFS=$'\n'
    files=($(fd -a --newer "$lastback" . "$dir" | sort -V))
    [[ -z ${files[@]} ]] && {
	echolor purple ":: –  Appears up-to-date."
	return
    }
    proceed=y
    [[ "$interactive_p" = "y" ]] && {
	dry_run=($(rsync -Parun "${files[@]}" "$cor_dir" | tail -n +2))
	[[ "${#dry_run[@]}" -ne 0 ]] && {
	    echolor yellow ":: The following ““${#dry_run[@]}”” files will be transferred:"
	    for l in ${dry_run[@]}
	    do
		echolor white "— $l"
	    done
	    echo -ne "\033[33m:: Proceed? (Y/n) "
	    read -r proceed
	} || {
	    echolor purple ":: –  Nothing to add."
	    return
	}
    }
    
    [[ "$proceed" = "y" ]] && {
	rsync --log-file="$mobilecache"/.transfer-log -Paru "${files[@]}" "$cor_dir"
    } || {
	echolor yellow ":: Nothing done."
    }
}

function back-all {
    IFS=$'\n'
    all_dirs=($(cat "$mobilecache"/dirs | xsv select 1))
    echolor yellow ":: The following directories in mobile will be backed."
    for k in ${all_dirs[@]}
    do
	echolor white "— $k"
    done
    echo -ne "\033[33m:: Proceed? (y/N) "
    read -r proceed
    [[ "$proceed" = "y" ]] || {
	echolor yellow ":: Nothing done."
	return
	}
    for k in ${all_dirs[@]}
    do
	back-from-dir "$k"
    done
}

[[ -d "$mobiledir" ]] || {
    echolor red ":: Mobile not mounted."
    exit
}
echolor yellow ":: The latest backup occurred on ““$lastback””"
while getopts ":7ad:t:i" opt
do
    case $opt in
	7)
	    lastback="1970-01-01 00:00:00"
	    echolor purple ":: Disregarding last backup time."
	    ;;
	a)
	    back-all
	    ;;
	d)
	    back-from-dir "$OPTARG"
	    ;;
	t)
	    lastback="$OPTARG"
	    echolor purple ":: Time will be considered to be ““$lastback””"
	    ;;
	i)
	    interactive_p=y
	    echolor yellow-red ":: Interactive mode ““ON””"
	    ;;
	\?)
	    echolor red ":: Invalid option."
	    ;;
    esac
done
bd >> "$mobilecache"/times


# TODO: getopts for disregarding lastback
