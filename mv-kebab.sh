#!/bin/bash

orig_name="$1"
ext_alone="$(echo $orig_name | awk -F '.' '{print $NF}')"
name_alone="$(echo $orig_name | sed "s/\.$ext_alone//")"
name_kebab="$(~/Repositories/scripts/kebabization.sh "$name_alone"; cat ~/.kebab)"
name_final="$(echo $name_kebab.$ext_alone)"
[ "$orig_name" == "$name_final" ] && echo ":: The filename is already kebab-compliant!" && exit
[ "$orig_name" == "$name_kebab" ] && echo ":: The filename is already kebab-compliant!" && exit
echo "$orig_name" | grep -q "\." && mv -iv "$orig_name" "$name_final" || mv -iv "$orig_name" "$name_kebab"
