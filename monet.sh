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
while getopts 'had:s:v' OPTION; do
    case "$OPTION" in
	"a") depth=999 ;;
	"d") img_dir="$OPTARG" ;;
	"s") searchterm="$OPTARG" ;;
	"h") hidden=1 ;;
	"v") exts="$vid_exts"
	     vids=1
	     matter="videos" ;;
	*) echolor red ":: Unknown option"; exit ;;
    esac
done
[[ -z "$img_dir" ]] && img_dir="."
[[ ! -d "$img_dir" ]] && {
    echolor red ":: Specified directory ““$img_dir”” does not exist."
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
    echolor red ":: No $matter found in directory ““$(basename $(realpath "$img_dir"))””"
    exit 1
}
echolor green-yellow ":: A total of ““${#images[@]}”” $matter were found."
if [[ ! -z "$searchterm" ]]
then
    echolor green-purple ":: Whittling down according to search term ““$searchterm””..."
    images_search=()
    for j in ${images[@]}
    do
	echo "$j" | awk -F '/' '{print $NF}' | grep -q "$searchterm" && \
	    images_search+=("$j")
    done
    [[ -z "$images_search" ]] && {
	echolor red ":: No $matter matching ““$searchterm”” were found."
	exit 1
    }
    images=(${images_search[@]})
    echolor green-yellow ":: A total of ““${#images[@]}”” $matter were found to match the search term."
fi
case "$vids" in
    1) mpv --osd-fractions --audio-samplerate=88200 --no-resume-playback --loop=inf -- ${images[@]} ;;
    *) sxiv -q -- ${images[@]} ;;
esac
