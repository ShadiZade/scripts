#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh

function h-to-w {
    echo hi
}


while getopts 'wh' OPTION; do
    case "$OPTION" in
	"h") pinyin_type=0 ;;
	"w") pinyin_type=1 ;;	    
	*) echo incorrect input; exit ;;
	esac
done
(( $OPTIND == 1 )) && pinyin_type=0

