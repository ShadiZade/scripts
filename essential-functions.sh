#!/bin/bash 

function echolor {
    case "$(echo "$1" | awk -F '-' '{print $1}')" in
	"black") color=30 ;;
	"red") color=31 ;;
	"green") color=32 ;;
	"yellow") color=33 ;;
	"blue") color=34 ;;
	"purple") color=35 ;;
	"default") color=36 ;;
	"white") color=37 ;;
	*) color=36 ;;
    esac
    case "$(echo "$1" | awk -F '-' '{print $2}')" in
	"black") highlight=30 ;;
	"red") highlight=31 ;;
	"green") highlight=32 ;;
	"yellow") highlight=33 ;;
	"blue") highlight=34 ;;
	"purple") highlight=35 ;;
	"default") highlight=36 ;;
	"white") highlight=37 ;;
	*) [[ "$color" -eq 37 ]] \
		&& highlight=33 \
		    || highlight=37 ;;
    esac
    text="$(echo "$2" | sed "s/““/\\\\033[${highlight}m/g;s/””/\\\\033[${color}m/g")"
    echo -e "\033["$color"m$text\033[0m"
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

function kebab {
    input_phrase="$1"
    echo -e "$input_phrase" \
	| iconv -c -f utf8 -t ascii//TRANSLIT \
	| perl -pe 's|&.*?;||g' \
	| tr -d '"’“”!?*=$:;#@^~()[]{}<>\t\\' \
	| sed 's|/| |g;s/\&/-and-/g;s/\%/-percent-/g' \
	| tr -d "'" \
	| tr '_ .|/+,\n–—' '-' \
	| tr '[A-Z]' '[a-z]' \
	| sed 's/--*/-/g;s/-$//g;s/^-//g'  \
	      > ~/.kebab
}

function basic-commit {
    cd "$1" \
	|| \
	{
	    echolor red ":: Cannot stat into directory ““$1””."
	    return
	}
    git add .
    git commit -m "$(date +"%Y%m%d%H%M")"
    cd - > /dev/null
}

function list-cutter {
    select_from=""
    IFS=$'\n'
    arr=($(echo $@))
    i=0
    echolor white -----------------------------------------
    for j in ${arr[@]}
    do
	[[ "$((i % 2))" -eq 0 ]] \
	    && color_alt="white" \
			|| color_alt="yellow"
	echolor "$color_alt" "$((i + 1))\t$j"
	echo "$j" | grep -q ',' \
			 && j="\"$j\""
	select_from+="$(echo -ne "$j,")"
	((i++))
    done
    echolor white -----------------------------------------
    echo -n ':: Select range: '
    read -r sel_range
    echo "$select_from" | xsv select "${sel_range:-$(seq -s ',' 1 ${#arr[@]})}"
}
