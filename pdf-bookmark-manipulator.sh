#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh 

pdffile="$2"
bkmkfile="bookmarks-$pdffile.pdfbkmk"
metafile="meta-$pdffile.pdfdata"

[[ -z "$1" ]] \
    && {
    echolor red ":: No command entered."
    exit
}
[[ -z "$2" ]] \
    && {
    echolor red ":: No PDF file specified."
    exit
}

function create-meta-file {
    [[ -e "$metafile" ]] \
	&& mv "$metafile" "$metafile-$(formatted-date-string)"
    echolor yellow ":: Creating meta file for ““$pdffile””"
    pdftk "$pdffile" dump_data_utf8 output "$metafile" || {
	echolor red ":: Meta file failed to generate."
	exit
    }
    echolor yellow ":: Meta file ““$metafile”” created!"
}

function create-bookmarks-file {
    [[ -e "$bkmkfile" ]] \
	&& {
	echolor yellow ":: Bookmark file ““$bkmkfile”” already exists."
	return
    }
    create-meta-file
    touch "$bkmkfile"
    cat "$metafile" | grep -i -A 3 "Bookmark" >> "$bkmkfile"
    echolor yellow ":: Bookmark file ““$bkmkfile”” created." 
}

function add-one-bookmark {
    echolor yellow " NEW BOOKMARK"
    echo -ne "1. Level: "
    read -r level
    echo -ne "2. Title: "
    read -r title
    echo -ne "3. Page: "
    read -r page
    {
	echo "BookmarkBegin"
	echo "BookmarkTitle: $title" 
	echo "BookmarkLevel: $level" 
	echo "BookmarkPageNumber: $page" 
    } >> "$bkmkfile"
}

function merge-data {
    mergee="$1"
    [[ -z "$mergee" ]] \
	&& {
	echolor red ":: No data file selected."
	return
    }
    [[ -e "$mergee" ]] \
	|| {
	echolor red ":: Such a data file as ““$mergee”” doesn’t exist."
	return
    }
    echolor yellow ":: Creating temporary file..."
    pdftk "$pdffile" cat output "temp_$pdffile"
    pdftk "temp_$pdffile" update_info_utf8 "$mergee" output "$pdffile"
    rm -f "temp_$pdffile"
    echolor yellow ":: Info for ““$pdffile”” updated."
}


function visualize-tree {
    case "$level" in
	1) padding="\t"; color=blue ;;
	2) padding="\t\t"; color=purple ;;
	3) padding="\t\t\t––"; color=green ;;
	4) padding="\t\t\t\t––––"; color=yellow ;;
	*) padding="\t\t\t\t\t––––>>>"; color=red ;;
    esac
    echolor "$color" "$padding$title\t\t\t\t\t......  $page"
}
    
function read-existing-bookmarks {
    bkmks="$(cat "$metafile" | grep -i -A 3 "BookmarkBegin")"
    until [[ -z "$bkmks" ]]
    do
	wbkmk="$(echo "$bkmks" | sed 4q)"
	title="$(echo "$wbkmk" | grep -i "BookmarkTitle" | awk -F ': ' '{print $2}')"
	level="$(echo "$wbkmk" | grep -i "BookmarkLevel" | awk -F ': ' '{print $2}')"
	page="$(echo "$wbkmk" | grep -i "BookmarkPageNumber" | awk -F ': ' '{print $2}')"
	visualize-tree
	bkmks="$(echo -n "$bkmks" | tail -n +5)"
    done
}

function clear-bookmarks-from-pdf {
    # DOES NOT WORK. PDFTK ONLY UPDATES BOOKMARKS, DOESN'T REMOVE THEM.
    create-meta-file
    cp "$metafile" "${metafile}nobkmk"
    sed -i '/^Bookmark/d' "${metafile}nobkmk"
    merge-data "${metafile}nobkmk"
    echolor yellow ":: Bookmarks removed from ““$pdffile””"
}

case "$1" in
    "dump")
	create-meta-file
	;;
    "add")
	create-bookmarks-file
	i=1
	while true
	do
	    echo -ne "\033[37m($i)\033[0m"
	    add-one-bookmark
	    ((i++))
	done
	;;
    "merge")
	merge-data "$3"
	;;
    "view")
	create-meta-file
	read-existing-bookmarks
	;;
    "clear")
	clear-bookmarks-from-pdf
	;;
    *)
	echolor red ":: Unknown command."
	;;
esac
