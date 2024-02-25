#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh

[ -z "$1" ] && read -r -p ":: Clear frequent-words? (y/N) " clr_p
[ "$clr_p" = "y" ] && echo "" > ~/.frequent-words | sed -i '/^$/d' ~/.frequent-words && echo ":: frequent-words cleared."
[ -z "$1" ] || echo "$1" >> ~/.frequent-words
[ -z "$1" ] || echo ":: \"$1\" added to your frequent-words file."
echo ":: These are the current contents of your frequent-words file:"
echo -e "\033[31m----------------------\033[0m"
cat ~/.frequent-words
echo -e "\033[31m----------------------\033[0m"

