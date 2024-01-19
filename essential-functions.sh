#!/bin/bash 

function echolor {
    case "$1" in
	"black") color=30 ;;
	"red") color=31 ;;
	"green") color=32 ;;
	"yellow") color=33 ;;
	"blue") color=34 ;;
	"purple") color=35 ;;
	"white") color=37 ;;
    esac
    echo -e "\033["$color"m$2\033[0m"
}

function random-string {
    [[ -z "$1" ]] \
	&& length=13 \
	       || length="$1"
    head /dev/urandom | tr -dc a-z0-9 | head -c "$length"
}

function scramble {
    [[ -z "$1" ]] \
	&& echolor yellow ":: Available options: 'files', 'dirs', and 'all'." \
	&& return
    conf_str="$(random-string 4)"
    echo -en "\033[31m:: Are you sure you want to scramble all \033[37m$(pwd)\033[31m file names? Type \033[37m$conf_str\033[31m to confirm.\033[0m "
    read -r conf_str_response
    [[ "$conf_str" != "$conf_str_response" ]] \
	&& echolor yellow ":: Nothing done." \
	&& return
    case "$1" in
	"files")
	    all_files=($(eza -1f))
	    ;;
	"dirs")
	    all_files=($(eza -1D))
	    ;;
	"all")
	    all_files=($(eza -1))
	    ;;
	*)
	    echolor yellow ":: Unknown option. Available options: 'files', 'dirs', and 'all'."
	    return
	    ;;
    esac
    counter=0
    [[ "${#all_files[@]}" -eq 0 ]] \
	&& echolor yellow ":: Directory is empty of specified files."
    for file_to_scramble in ${all_files[@]};
    do
	ext="${file_to_scramble##*.}"
	mv -iv "$file_to_scramble" "$(random-string)"."$ext"
	((counter++))
    done
    echolor yellow ":: Scrambled $counter files."
}
