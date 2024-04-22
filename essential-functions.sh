#!/bin/bash 
source ~/Repositories/dotfiles/zsh/variables 

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
    [[ "$3" -eq 1 ]] && nonewline="-n" || nonewline="" # add "1" as a 3rd argument to add -n to echo
    echo $nonewline -e "\033["$color"m$text\033[0m"
}

function random-string {
    head /dev/urandom | tr -dc a-z0-9 | head -c "${1:-13}"
}

function scramble-file-names {
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
	mv -iv -- "$file_to_scramble" "$(random-string)"."$ext"
	((counter++))
    done
    echolor yellow ":: Scrambled $counter files."
}

function kebab {
    input_phrase="$@"
    echo -e "$input_phrase" \
	| iconv -c -f utf8 -t ascii//TRANSLIT \
	| perl -pe 's|&.*?;||g' \
	| tr -d '"’“”!?*=$:;#@^~()[]{}<>\t\\' \
	| sed 's|/| |g;s/\&/-and-/g;s/\%/-percent-/g' \
	| tr -d "'" \
	| tr '_ .|/+,\n–—' '-' \
	| tr '[A-Z]' '[a-z]' \
	| sed 's/--*/-/g;s/-$//g;s/^-//g'  \
	      > "$usdd/kebab"
}

function output-kebabized-string {
    kebab "$@"
    cat "$usdd/kebab"
}

function copy-kebabized-string {
    output-kebabized-string "$@"
    cat "$usdd/kebab" | xclip -selection clipboard
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
# what the fuck is this function and when did I write it
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

function move-to-trash {
    trashdir="/home/oak/.local/share/Trash"
    fd -q "^$1$" "$trashdir"/files && {
	postdelname="$1-$(date +"%Y_%m_%d_%H_%M_%S")"
	command mv -n -- "$1" "$trashdir"/files/"$postdelname" \
	    || {
	    echolor red ":: Error moving ““$1”” to trash as ““$postdelname””"
	    echolor red ":: Exiting immediately..."
	    return
	}
    } || {
	postdelname="$1"
	command mv -n -- "$1" "$trashdir"/files/ \
	    || {
	    echolor red ":: Error moving ““$1”” to trash"
	    return
	}
    }
    echo "$(date +"%Y-%m-%d %H:%M:%S")   ¼⅓   $(basename "$1")   ¼⅓   $(basename "$postdelname")" \
	 >> "$trashdir"/deletetimes
    [ "$1" = "$postdelname" ] && {
	echolor blue ":: File ““$1”” moved to trash."
    } || {
	echolor purple ":: File ““$1”” moved to trash as ““$postdelname””"
    }
}

function move-to-trash-recursively {
    IFS=$'\n'
    files_to_trash=("$@")
    i=0
    for j in ${files_to_trash[@]}
    do
	move-to-trash "$j"
	((i++))
    done
    export number_of_files_trashed="$i"
    unset IFS
}

function restore-files-from-trash {
    IFS=$'\n'
    trashdir="$HOME/.local/share/Trash"
    restfiles=($(cat "$trashdir"/deletetimes | sort -V | tail -n "${1:-1}" | awk -F '   ¼⅓   ' '{print $2, "¼⅓", $3}'))
    [ -z "$restfiles" ] && {
	echolor red ":: No files chosen."
	return
    }
    echolor yellow ":: Restoring the following files from trash:"
    for j in ${restfiles[@]}
    do
	echolor white "- $(echo "$j" | awk -F ' ¼⅓ ' '{print $2}')" 
    done
    proceed_p=n
    echo -ne "\033[33m:: Proceed? (y/N) "
    read -r proceed_p
    [ "$proceed_p" = "y" ] || {
	echolor yellow ":: Doing nothing."
	return
    }
    for j in ${restfiles[@]}
    do
	normal_name="$(echo "$j" | awk -F ' ¼⅓ ' '{print $1}')"
	trash_name="$(echo "$j" | awk -F ' ¼⅓ ' '{print $2}')"
	command mv -n -- "$trashdir"/files/"$trash_name" ./"$normal_name" && {
	    [ "$trash_name" = "$normal_name" ] \
		&& echolor blue ":: File ““$normal_name”” restored from trash." \
		    || echolor purple ":: File ““$trash_name”” restored from trash as ““$normal_name””"
	} || {
	    echolor red ":: Error restoring ““$trash_name”” from trash as ““$normal_name””"
	    return
	}
	sed -i "/¼⅓   $normal_name   ¼⅓   $trash_name/d;/^$/d" "$trashdir"/deletetimes
    done
    unset IFS
}

function extension-determiner {
    grep "$(mimetype -Mb "$1")" ~/.local/share/user-scripts/mime-extensions.csv \
	| ifne xsv select 2 2>/dev/null
}

function date-string {
    date_string="$(date +"%Y%m%d%H%M%S")"
    case "$1" in
	"long") date_string="$(date +"%Y-%m-%d %H:%M:%S")" ;;
	"") echo -n ;;
	"y") date_string="$(echo $date_string | cut -c-4)" ;;
	"ym") date_string="$(echo $date_string | cut -c-6)" ;;
	"ymd") date_string="$(echo $date_string | cut -c-8)" ;;
	"ymdh") date_string="$(echo $date_string | cut -c-10)" ;;
	"ymdhm") date_string="$(echo $date_string | cut -c-12)" ;;
	"ymdhms") date_string="$(echo $date_string | cut -c-14)" ;;
	*) echo -n ;;
    esac
    echo $date_string
}

function exchange-names {
    [[ -e "$1" ]] || {
	echolor red ":: Please input valid filenames."
	return
    }
    [[ -e "$2" ]] || {
	echolor red ":: Please input second filename."
	return
    }
    name1="$(echo $1 | sed 's|/||g')"
    name2="$(echo $2 | sed 's|/||g')"
    conf_str="$(random-string 2)"
    echolor yellow ":: Are you sure to exchange ““$name1”” and ““$name2””?"
    echolor yellow-green ":: Type ““$conf_str”” to confirm."
    echo -ne "\033[37m>>> \033[0m"
    read -r conf_str_response
    [[ "$conf_str" != "$conf_str_response" ]] \
	&& echolor red ":: Nothing done." \
	&& return
    mv -n -- "$name1" .temp-"$name2" || {
	echolor red ":: Failure! (error code ““1””)"
	return
    }
    mv -n -- "$name2" "$name1" || {
        echolor red ":: Failure! (error code ““2””)"
	return
    }
    mv -n -- .temp-"$name2" "$name2" || {
	echolor red ":: Failure! (error code ““3””)"
	return
    }
    echolor yellow ":: Files ““$name1”” and ““$name2”” have successfully exchanged names."
}

function battery-warner {
    batterypercent="$(upower -i /org/freedesktop/UPower/devices/battery_BAT1 | grep percentage | awk '{print $2}' | tr -d '% ')"
    [[ "$batterypercent" -gt 25 ]] \
	&& batterystatus="0" || {
	    batterystate="$(upower -i /org/freedesktop/UPower/devices/battery_BAT1 | grep state | awk '{print $2}' | tr -d ' ')"
	    [[ "$batterystate" = "discharging" ]] \
		&& batterystatus="1" \
		    || batterystatus="0"
	}
}

function warning-bloops {
    mpv --loop=10 /home/oak/.local/share/user-scripts/sounds/bloops.oga
}

# function ¿ {
#     : function ¿ interrogates functions and aliases in bash, enabling them to be self-documenting.
#     :
#     : in case $1 is an alias, ¿ will show the definition of the alias.
#     :
#     : in case $1 is a function, ¿ will show the location of the definition as well as the
#     : docstring, which is defined by the builtin bash null function ":".

#     type_of="$(type "$1" | awk '{print $4,$5}')"
#     case "$type_of" in
# 	"alias for")
# 	    echolor yellow-purple ":: ““$1”” is an alias for:"
# 	    type "$1" | sed "s/$1 is an alias for //g" | bat -Ppl bash
# 	    ;;
# 	"shell function")
# 	    echolor yellow-purple ":: ““$1”” is a function defined in ““$(type "$1" | awk '{print $NF}')””"
# 	    declare -f "$1" | sed '1d' | head -n -1 | grep "^\s*:" | bat -Ppl bash
# 	;;
# 	*)
# 	    echolor red ":: Unrecognized type."
# 	;;
#     esac
# # TODO find a better way for this
# }
