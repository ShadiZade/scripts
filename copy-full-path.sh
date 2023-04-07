#!/bin/bash 

get-values () {
	query_a="$1"
	[ "$query_a" = '.' ] && path_copied="$(pwd)" || path_copied="$(echo $(pwd)/$(ls -1 | grep "$query_a"))"
}

copy-and-show () {
	get-values $1
	echo "$path_copied" | tr -d '\n' | xclip -selection clipboard
	echo "$path_copied"	| tr -d '\n'
}
