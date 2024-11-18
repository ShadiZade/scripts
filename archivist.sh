#!/bin/bash
source ~/Repositories/scripts/essential-functions

arcv_dir="$HOME/Archives"
vid_type=(mp4 webm ogv wmv mkv flv gifv avi mpg m4v)
img_type=(jpg jpeg png avif webp gif jxl svg tif tiff bmp)
doc_type=(pdf ps epub mobi azw3 md txt html xhtml mhtml)
snd_type=(mp3 ogg oga mogg wma wav flac ape opus alac m4a)

function search {
    this_arcv="$(eza -1D "$arcv_dir" | fzf --prompt "Select archive: ")"
    [[ -z "$this_arcv" ]] && {
	echolor red ":: Archive not chosen."
	exit
    }
    cd "$arcv_dir"/"$this_arcv"
    echolor yellow ":: Searching in archive ““$this_arcv””..."
    echolor yellow ":: Enter desired filetype:"
    echolor blue "==> [V]ideo [I]mage [D]ocument [S]ound"
    echolor blue "==> " 1
    read -r query_type
    query-type-processor "$query_type"
    echo $query_vid
    echo $query_img
    echo $query_doc
    echo $query_snd
}

function query-type-processor {
    qu="$1"
    query_vid=0
    query_img=0
    query_doc=0
    query_snd=0
    echo "$qu" | grep -qi "v" && {
	export query_vid=1
	qu="$(echo "$qu" | sed 's/v//gi')"
    }
    echo "$qu" | grep -qi "i" && {
	export query_img=1
	qu="$(echo "$qu" | sed 's/i//gi')"
    }
    echo "$qu" | grep -qi "d" && {
	export query_doc=1
	qu="$(echo "$qu" | sed 's/d//gi')"
    }
    echo "$qu" | grep -qi "s" && {
	export query_snd=1
	qu="$(echo "$qu" | sed 's/s//gi')"
    }
    [[ -z "$qu" ]] || {
	echolor red ":: Unknown elements in response: ““$qu””"
	exit
    }
    [[ "$((query_vid + query_img + query_doc + query_snd))" -eq 0 ]] && {
	echolor red ":: You have chosen nothing. Exiting..."
	exit
    }
}

search
