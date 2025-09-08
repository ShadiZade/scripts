#!/bin/bash
source ~/Repositories/scripts/essential-functions

depth=1
img_exts='\.jpg$|\.jpeg$|\.png$|\.gif$|\.webp$|\.jxl$|\.jpg_large$|\.jp2$|\.svg$|\.tif$|\.avif$|\.jfif$'
vid_exts='\.mkv$|\.avi$|\.mp4$|\.ts$|\.mov$|\.webm$|\.m4v$'
exts="$img_exts"
img_dir=''
searchterm=''
images=()
hidden=0
vids=0
matter="images"
children=' itself.'
count_only=0
log_results=0
randomness=0
time_after="1970-01-01"
time_before="$(date -d tomorrow +'%Y-%m-%d')"
function date-formatter {
    date -d "$1" +'%Y-%m-%d %H:%M:%S' 2>/dev/null || return 1
}
while getopts 'had:s:vclA:B:r:' OPTION; do
    case "$OPTION" in
	"a") depth=999
	     children=' or its children.' ;;
	"d") img_dir="$OPTARG" ;;
	"s") searchterm="$OPTARG" ;;
	"h") hidden=1 ;;
	"v") exts="$vid_exts"
	     vids=1
	     matter="videos" ;;
	"r") randomness=1
	     num_rand_files="${OPTARG:-1}" ;;
	"c") count_only=1 ;;
	"l") log_results=1 ;;
	"A") date-formatter "$OPTARG" >/dev/null || exit 1
	     time_after="$OPTARG" ;;
	"B") date-formatter "$OPTARG" >/dev/null || exit 1
	     time_before="$OPTARG" ;;
	*) echolor red ":: Unknown option"; exit ;;
    esac
done
[[ -z "$img_dir" ]] && img_dir="."
[[ ! -d "$img_dir" ]] && {
    [[ "$count_only" -eq 0 ]] && {
	echolor red ":: Specified directory ““$img_dir”” does not exist."
    } || {
	echo 0
    }
    exit 1
}
IFS=$'\n'
if [[ "$hidden" -eq 1 ]]
then
    images=($(fd -IH --newer "$time_after" --older "$time_before" -d "$depth" "$exts" "$img_dir" | sort -V))
else
    images=($(fd -I --newer "$time_after" --older "$time_before" -d "$depth" "$exts" "$img_dir" | sort -V))
fi
[[ -z "$images" ]] && {
    [[ "$count_only" -eq 0 ]] && {
	echolor red ":: No $matter found in directory ““$(basename $(realpath "$img_dir"))””$children"
    } || {
	echo 0
    }
    exit 1
}
[[ "$count_only" -eq 0 ]] && {
    echolor green-yellow ":: ““${#images[@]}”” relevant $matter were found in directory ““$(basename $(realpath "$img_dir"))””$children"
}
if [[ ! -z "$searchterm" ]]
then
    searchterm="$(echo "$searchterm" | tr '[A-Z]' '[a-z]')"
    [[ "$count_only" -eq 0 ]] && {
	echolor green-purple ":: Whittling down according to search term ““$searchterm””..."
    }
    images_search=($(for j in ${images[@]}; do echo "$j"; done | awk -F '/' "tolower(\$NF) ~ /$searchterm/"))
    [[ -z "$images_search" ]] && {
	[[ "$count_only" -eq 0 ]] && {
	    echolor red ":: No $matter matching ““$searchterm”” were found."
	} || {
	    echo 0
	}
	exit 1
    }
    images=(${images_search[@]})
    [[ "$count_only" -eq 0 ]] && {
	echolor green-yellow ":: A total of ““${#images[@]}”” $matter were found to match the search term."
    }
fi

[[ "$randomness" -eq 1 ]] && {
   [[ "$count_only" -eq 0 ]] && {
       [[ "$num_rand_files" -gt 1 ]] && echolor green-purple ":: Giving ““$num_rand_files”” random results..."
       [[ "$num_rand_files" -eq 1 ]] && echolor green-purple ":: Giving a random result..."
       [[ "$num_rand_files" -eq 0 ]] && {
	   num_rand_files="${#images[@]}"
	   echolor green-purple ":: Scrambling all ““$num_rand_files”” results..."
       }
   }
    images_rand=()
    for j in $(shuf --random-source=/dev/urandom -n "$num_rand_files" -i "1-${#images[@]}")
    do
	images_rand+=("${images[$((j - 1))]}")
    done
    images=(${images_rand[@]})
    [[ "$count_only" -eq 0 ]] && {
	[[ "$num_rand_files" -ne "${#images[@]}" ]] && {
	    echolor green-purple ":: Could not supply ““$num_rand_files”” random results, only ““${#images[@]}””..."
	}
    }
}

[[ "$log_results" -eq 1 ]] && {
    logfile="$HOME/.local/logs/monet/monet-$(date-string)-$searchterm.log"
    [[ "$count_only" -eq 0 ]] && {
	echolor green-yellow ":: Logging results to ““$logfile”””" 1
    }
    for j in ${images[@]}
    do
	echo "$(realpath $j)" >> "$logfile"
    done
    [[ "$count_only" -eq 0 ]] && {
	clear-line
	echolor green-yellow ":: Results logged to ““$logfile””"
    }
}
[[ "$count_only" -eq 1 ]] && {
    echo ${#images[@]}
    exit 0
}
[[ "${#images[@]}" -gt 3000 ]] && {
    open_p="y"
    echolor yellow-red ":: The search yielded ““${#images[@]}”” results. Open? (Y/n) " 1
    read -r open_p
    [[ "$open_p" = "n" ]] && exit
}
case "$vids" in
    1) mpv --osd-fractions --really-quiet --volume=100 --volume-max=200 --audio-samplerate=88200 --no-resume-playback --loop=inf -- ${images[@]} ;;
    *) sxiv -q -- ${images[@]} ;;
esac

unset IFS
