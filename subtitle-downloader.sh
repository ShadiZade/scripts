#!/bin/bash
source ~/Repositories/scripts/essential-functions

levver () {
    while read line
    do
	echo "$(lev "$1" "$line"),$line"
    done
}

if [[ -e "$1" ]]
then
    subzip="$1"
else
    subzip="$(eza --absolute=on --no-quotes -1f "$HOME/Downloads/" | grep "zip$" | ifne fzf)"
fi

[[ -e "$subzip" ]] || {
    echolor red ":: No .zip file found."
    exit
}

mv "$subzip" "./.sub.zip"

unzip -d .ext-sub .sub.zip

sub="$(eza --no-quotes -1f .ext-sub | sed '/^$/d' | sort | grep -E 'srt$|vtt$|part$' | fzf)"
[[ -z "$sub" ]] && {
    echolor red ":: No file chosen."
    exit
}

ep="$(eza --no-quotes -1fX --show-symlinks -I '*.srt' | sed '/^$/d' | levver "$sub" | sort -V | xan select 1 | grep -Ev 'srt$|vtt$|part$' | fzf)"
[[ -z "$ep" ]] && {
    echolor red ":: No file chosen."
    exit
}

ep_ext="$(echo "$ep" | awk -F '.' '{print $NF}')"
sub_ext="$(echo "$sub" | awk -F '.' '{print $NF}')"
ep="$(echo "$ep" | sed "s/$ep_ext$/en.$sub_ext/g")"

mv -v ".ext-sub/$sub" "./$ep"
rm -vrf '.ext-sub' '.sub.zip'
