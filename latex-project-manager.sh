#!/bin/bash

# non-interactive functions
function list-project-files {
    check-for-latex-directory \
	&& eza -l --icons --no-user --time-style=iso --sort=newest --color-scale all \
	       || echo -e "\033[33m:: Nothing here for LPM to work with.\033[0m"
}

function check-for-latex-directory {
    fd -q -d 1 "project.conf"
}

function check-dependencies {
    dependencies=("xelatex" "bibtex" "eza" "fd" "zathura")
    # continue this later    
}

# interactive functions
function create {
   [ -z "$1" ] && echo -e "\033[33m:: Please enter project name.\033[0m" && exit
   fd -q "^$1$" && echo -e "\033[33m:: Clobber prevented. Choose a different name.\033[0m" && exit
   name="$1"
   x=0
   cp -nr ~/Misc/templates/latex/ ./"$name" \
       && echo -e "\033[32m:: Template copied.\033[0m" \
   	   || echo -e "\033[33m:: Template not copied.\033[0m"
   sed -i "s/REPLACEHERE/$name/g" ./"$name"/set.sh && ((x++))
   mv -n ./"$name"/template.tex ./"$name"/"$name".tex && ((x++))
   [ "$x" = 2 ] \
       && echo -e "\033[32m:: All parameters replaced.\033[0m" \
   	   || echo -e "\033[33m:: Not all parameters replaced.\033[0m"
   cd ./"$name" || exit
   [ "$x" = 2 ] \
       && xelatex -interaction=batchmode ./"$name".tex \
       && echo -e "\033[32m:: LaTeX files initialized.\033[0m" \
       && ((x++))
   [ "$x" = 3 ] \
       && echo -e "\033[35m:: Welcome to your project: $name.\033[0m"
}

function see-pdf-file {
echo hi
}

function project-info {
echo hi
}

function show-help {
echo hi
}

function set-tex-file {
echo hi
}


check-dependencies
[ -z "$1" ] && list-project-files && exit
comd="$1"

case "$comd" in
    "create") create "$2" ;;
    "see") ;;
    "set") ;;
    "help") ;;
    "info") ;;
    *) echo -e "\033[33m:: Unrecognized command.\033[0m" ;;
esac

