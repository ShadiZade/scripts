#!/bin/bash
source ~/Repositories/scripts/essential-functions
# fuck you, WebP. I can't believe they killed JPEG XL for your sake.

echolor yellow "$(figlet <<< "FUCK WEBP")"
numfiles="${#@}"
[[ -z "$@" ]] && exit 1
[[ "$numfiles" -ge 3 ]] && {
    echolor yellow-aquamarine ":: About to convert ““${#@}”” files. (press <return> to continue) " 1
    read
}
i=1
for j in "${@}"
do
    [[ ! -e "$j" ]] && {
	echolor red ":: File ““$j”” does not exist. skipping..."
	continue
    }
    file_mime="$(mimetype -Mb "$j" | awk -F '/' '{print $1}')"
    file_ext="$(extension-determiner "$j")"
    echolor yellow-aquamarine ":: ““($i/$numfiles)”” File ““$j”” was detected"
    echolor yellow-aquamarine "\t└── as ““$file_mime””\n\t└── with extension ““$file_ext””"
    case "$file_mime" in
	"video")
	    newname="${j%.*}.mp4"
	    if [[ "$newname" = "$j" ]]
	    then
		echolor red ":: File ““$j”” is already in desired format."
	    else
		echolor yellow-aquamarine "======> Converting to mp4..."
		ffmpeg -loglevel 8 -i "$j" "$newname" && {
		    rm -f "$j" > /dev/null
		} || {
		    echolor red "======> Failed to convert ““$j””"
		}
	    fi
	    ;;
	"image")
	    newname="${j%.*}.jxl"
	    if [[ "$newname" = "$j" ]]
	    then
		echolor red ":: File ““$j”” is already in desired format."
	    else
		echolor yellow-aquamarine "======> Converting to jxl..."
		magick "$j" "$newname" && {
		    rm -f "$j" > /dev/null
		} || {
		    echolor red "======> Failed to convert ““$j””"
		}
	    fi
    	    ;;
	*)
	    echolor red ":: File ““$j”” is neither video nor image."
	    ;;
    esac
    echo
    ((i++))
done
