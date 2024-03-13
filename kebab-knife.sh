#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh

[ -z "$1" ] \
    && echo -e "\033[33m:: Please enter filename.\033[0m" \
    && exit
[ -e "$1" ] || {
    echolor yellow ":: File does not exist."
    exit
}
~/Repositories/scripts/mv-kebab.sh "$1" 

yt_url_p='n'
echo "$1" \
    | grep -q "\]\." && {
    yt_url="$(echo "$1" | awk -F '[' '{print $NF}' | awk -F ']' '{print $1}')"
    yt_url="$(echo "["$yt_url"]" | sed 's/-/–/g')"
    yt_url="$(echo "-$yt_url")"        
}
    # hyphen is sedded into an en-dash for convenience
    # this is reversed in the simple-reorder function
    
init_kebab="$(echo "$(cat "$usdd/kebab")"$yt_url)"
ext="$(echo .$(echo "$1" | awk -F '.' '{print $NF}'))"
echo "$1" | grep -q "\." \
    || ext=""
[[ -d "$1" ]] \
    && ext=""    
purename="$(echo "$init_kebab" | sed 's/\..*//g')"
headers="$(echo "$purename" | xsv headers -d '-')"
tot_num_indices="$(echo "$headers" | tail -n 1 | awk '{print $1}')"
echo -e "\033[37m$headers\033[0m"
echo -e ":: Choose order (as such: '1 4 8 3' or '1-4')"
read -r -p ":: or enter 'a' for addition or 'd' for deletion: " modnum

function sequencer {
    echo "$modnum" | grep -q '-' \
	|| return
    modnum="$(echo "$modnum" | sed 's/-/ /')"
    modnum="$(seq -s " " $modnum)"
}


function simple-reorder {
modnum="$(echo $modnum | sed 's/ /,/g')"
echo -e ":: old name is \033[33m$(echo $init_kebab$ext)\033[0m"
echo -e ":: new name is \033[37m$(echo $purename | xsv select -d '-' $modnum | sed 's/,/-/g')$ext\033[0m"
read -r -p ":: Perform the move? (Y/n) " proceed
proceed=${proceed:-y}
case "$proceed" in
    "n") echo ":: Move NOT performed."
         exit ;;
    *) init_kebab="$(echo "$init_kebab" | sed 's/–/-/g')"
       endashed_name="$(echo "$purename" | xsv select -d '-' $modnum | sed 's/,/-/g')"
       mv -nv -- "$(echo "$init_kebab$ext")" "$endashed_name$ext"
       purename="$(echo "$endashed_name" | sed 's/–/-/g')"
       [ "$purename" = "$endashed_name" ] \
	   || mv -n -- "$endashed_name$ext" "$purename$ext"
       ;;
    esac
}

function delete-some {
    i=0
    modnum="$(seq -s " " 1 $tot_num_indices)"
    read -r -p ":: please list indices of unwanted words with whitespace in between: " -a deleted
    echo "${deleted[@]}" | grep -q '-' \
	&& deleted="$(echo "$deleted" | sed 's/-/ /')" \
	&& deleted_seq="$(seq -s " " $deleted)" \
	&& IFS=" " read -r -a deleted <<< "$deleted_seq"
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
    echo -e ":: Choose order (as such: '1 4 8 3' or '1-4')"
    read -r -p ":: or enter 'd' for deletion (you cannot enter 'a'), or nothing to confirm: " modnum
    sequencer
    case $modnum in
	d) delete-some ;;
	a) echo -e "\033[33m:: We told you not to use 'a' again." \
		 && exit ;;
	"") modnum="$(seq -s " " 1 $tot_num_indices)"; simple-reorder ;;
	*) simple-reorder ;;
    esac
}

sequencer
case "$modnum" in
    a) add-more ;;
    d) delete-some ;;
    "") exit ;;
    *) simple-reorder ;;
esac
