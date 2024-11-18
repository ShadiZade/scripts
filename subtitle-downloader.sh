#!/bin/bash
source ~/Repositories/scripts/essential-functions

if [[ -e "$1" ]]
then
    mv "$1" "./.sub.zip"
else
    wget --continue --no-use-server-timestamps -O ".sub.zip" -nc -t 0 -- "$1" || exit
fi

unzip -d .ext-sub .sub.zip

sub="$(eza --no-quotes -1f .ext-sub | sed '/^$/d' | sort | grep -E 'srt$|vtt$|part$' | fzf)"
[[ -z "$sub" ]] && {
    echolor red ":: No file chosen."
    exit
}

ep="$(eza --no-quotes -1fX --show-symlinks | sed '/^$/d' | sort | grep -Ev 'srt$|vtt$|part$' | fzf)"
[[ -z "$ep" ]] && {
    echolor red ":: No file chosen."
    exit
}

ep_ext="$(echo "$ep" | awk -F '.' '{print $NF}')"
sub_ext="$(echo "$sub" | awk -F '.' '{print $NF}')"
ep="$(echo "$ep" | sed "s/$ep_ext$/en.$sub_ext/g")"

mv -v ".ext-sub/$sub" "./$ep"
rm -vrf '.ext-sub' '.sub.zip'
