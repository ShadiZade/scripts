#!/bin/bash

orig_name="$1"
echo $orig_name | grep -q "/" && echo ":: This operation can only be performed inside the directory." && exit
ext_alone="$(echo $orig_name | awk -F '.' '{print $NF}')"
name_alone="$(echo $orig_name | sed "s/\.$ext_alone//")"
name_kebab="$(~/Repositories/scripts/kebabization.sh "$name_alone"; cat ~/.kebab)"
name_final="$(echo $name_kebab.$ext_alone)"
[ "$orig_name" == "$name_final" ] && echo ":: Filename is already kebab-compliant!" && exit
[ "$orig_name" == "$name_kebab" ] && echo ":: Filename is already kebab-compliant!" && exit
echo "$orig_name" | grep -q "\." || name_final="$name_kebab"
echo -e ":: old name is \033[33m$orig_name\033[0m"
echo -e ":: new name is \033[37m$name_final\033[0m"
read -r -p ":: Perform the move? (Y/n) " proceed
proceed=${proceed:-y}
[ "$proceed" != "y" ] && echo ":: Move NOT performed." && exit
mv -iv "$orig_name" "$name_final"
