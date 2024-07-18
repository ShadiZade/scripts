#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh

wget --continue --no-use-server-timestamps -O ".sub.zip" -nc -t 0 -- "$1"
unzip -d .ext-sub .sub.zip

sub="$(eza --no-quotes -1f .ext-sub | sed '/^$/d' | sort | grep -E 'srt$|vtt$|part$' | fzf)"
[[ -z "$sub" ]] && {
    echolor red ":: No file chosen."
    exit
}

ep="$(echo -e "$(eza --no-quotes -1f)\n$(fd -t l -d 1)" | sed '/^$/d' | sort | grep -Ev 'srt$|vtt$|part$' | fzf)"
[[ -z "$ep" ]] && {
    echolor red ":: No file chosen."
    exit
}

ep_ext="$(echo "$ep" | awk -F '.' '{print $NF}')"
sub_ext="$(echo "$sub" | awk -F '.' '{print $NF}')"
ep="$(echo "$ep" | sed "s/$ep_ext$/en.$sub_ext/g")"

mv -v ".ext-sub/$sub" "./$ep"
rm -vrf '.ext-sub' '.sub.zip'