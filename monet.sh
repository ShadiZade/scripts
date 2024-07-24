#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh

depth=1
img_exts='\.jpg$|\.jpeg$|\.png$|\.gif$|\.webp$|\.jxl$|\.jpg_large$|\.jp2$|\.svg$|\.tif$|\.avif$'
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
while getopts 'had:s:vcl' OPTION; do
    case "$OPTION" in
	"a") depth=999
	     children=' or its children.' ;;
	"d") img_dir="$OPTARG" ;;
	"s") searchterm="$OPTARG" ;;
	"h") hidden=1 ;;
	"v") exts="$vid_exts"
	     vids=1
	     matter="videos" ;;
	"c") count_only=1 ;;
	"l") log_results=1 ;;
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
    images=($(fd -H -d "$depth" "$exts" "$img_dir" | sort -V))
else
    images=($(fd -d "$depth" "$exts" "$img_dir" | sort -V))
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
    echolor green-yellow ":: ““${#images[@]}”” $matter were found in directory ““$(basename $(realpath "$img_dir"))””$children"
}
if [[ ! -z "$searchterm" ]]
then
    [[ "$count_only" -eq 0 ]] && {
	echolor green-purple ":: Whittling down according to search term ““$searchterm””..."
    }
    images_search=($(for j in ${images[@]}; do echo "$j"; done | awk -F '/' "\$NF ~ /$searchterm/"))
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
    1) mpv --osd-fractions --really-quiet --audio-samplerate=88200 --no-resume-playback --loop=inf -- ${images[@]} ;;
    *) sxiv -q -- ${images[@]} ;;
esac
