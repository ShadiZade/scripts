#!/bin/bash

read -r -p "Title: " title
read -r -p "Artist: " artist
read -r -p "Genre: " genre
[ -z "$1" ] && working_file="$(ls -1 | fzf)" || working_file="$1"

[ -z "$title" ] && title_p=n || title_p=y
[ -z "$artist" ] && artist_p=n || artist_p=y
[ -z "$genre" ] && genre_p=n || genre_p=y
all_p="$title_p$artist_p$genre_p"

case $all_p in
    yyy) taffy -t "$title" -r "$artist" -g "$genre" "$working_file" ;;
    yyn) taffy -t "$title" -r "$artist" "$working_file" ;;
    ynn) taffy -t "$title" "$working_file" ;;
    nnn) taffy "$working_file" ;;
    nny) taffy -g "$genre" "$working_file" ;;
    nyy) taffy -r "$artist" -g "$genre" "$working_file" ;;
    yny) taffy -t "$title" -g "$genre" "$working_file" ;;
    nyn) taffy -r "$artist" "$working_file" ;;
esac

