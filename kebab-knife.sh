#!/bin/bash

[ -z "$1" ] \
    && echo -e "\033[33m:: Please enter filename.\033[0m" \
    && exit
~/Repositories/scripts/mv-kebab.sh "$1"
init_kebab="$(cat ~/.kebab)"
ext="$(echo .$(echo "$1" | awk -F '.' '{print $NF}'))"
echo "$1" | grep -q "\." \
    || ext=""
purename="$(echo "$init_kebab" | sed 's/\..*//g')"
headers="$(echo "$purename" | xsv headers -d '-')"
tot_num_indices="$(echo "$headers" | tail -n 1 | awk '{print $1}')"
echo -e "\033[37m$headers\033[0m"
echo -e ":: Choose order (as such: 1 4 3 8)"
read -r -p ":: or enter 'a' for addition or 'd' for deletion: " modnum
     

function simple-reorder {
modnum="$(echo $modnum | sed 's/ /,/g')"
echo -e ":: old name is \033[33m$(echo $init_kebab$ext)\033[0m"
echo -e ":: new name is \033[37m$(echo $purename | xsv select -d '-' $modnum | sed 's/,/-/g')$ext\033[0m"
read -r -p ":: Perform the move? (Y/n) " proceed
proceed=${proceed:-y}
case "$proceed" in
    "n") echo ":: Move NOT performed."
         exit ;;
    *) mv -nv "$(echo $init_kebab$ext)" "$(echo $purename | xsv select -d '-' $modnum | sed 's/,/-/g')$ext" ;;
esac
}

function delete-some {
    i=0
    modnum="$(seq -s " " 1 $tot_num_indices)"
    read -r -p ":: please list indices of unwanted words with whitespace in between: " -a deleted
    while [ "$i" -lt "$(echo ${#deleted[@]})" ]; do
	modnum="$(echo " $modnum " | sed "s/ ${deleted[$i]} / /g")"
	((i++))
    done
    simple-reorder
}

function add-more {
    read -r -p ":: please add new words with whitespaces in between: " added
    added="$(echo $added | sed 's/ /-/g')"
    purename="$(echo $purename-$added)"
    headers="$(echo "$purename" | xsv headers -d '-')"
    tot_num_indices="$(echo "$headers" | tail -n 1 | awk '{print $1}')"
    echo -e "\033[37m$headers\033[0m"
    echo -e ":: Choose order (as such: 1 4 3 8)"
    read -r -p ":: or enter 'd' for deletion (you cannot enter 'a'), or nothing to confirm: " modnum
    case $modnum in
	d) delete-some ;;
	a) echo -e "\033[33m:: We told you not to use 'a' again." \
		 && exit ;;
	"") modnum="$(seq -s " " 1 $tot_num_indices)"; simple-reorder ;;
	*) simple-reorder ;;
    esac
}

case "$modnum" in
    a) add-more ;;
    d) delete-some ;;
    "") exit ;;
    *) simple-reorder ;;
esac
