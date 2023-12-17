#!/bin/bash

# non-interactive functions
function list-project-files {
    check-for-latex-directory
    eza -l --icons --no-user --time-style=iso --sort=modified --color-scale all --color=always \
	--group-directories-first --no-quotes --no-permissions --git -I "*log|*aux|*toc|*conf|*blg|*bbl|set.sh"
}

function check-for-latex-directory {
    fd -q -d 1 "project.conf" || exist_tex="NO"
    [ "$exist_tex" = "NO" ] && echo -e "\033[33m:: Nothing here for LPM to work with.\033[0m" && exit
}

function check-dependencies {
    dependencies=("xelatex" "bibtex" "eza" "fd" "zathura" "texcount")
    # continue this later    
}

function conf-info-extract {
    check-for-latex-directory
    cat project.conf | grep "^$1 = " | awk -F ' = ' '{print $NF}'
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
   echo -e "project_name = $name" >> project.conf
   [ "$x" = 2 ] \
       && xelatex -interaction=batchmode ./"$name".tex \
       && echo -e "\033[32m:: LaTeX files initialized.\033[0m" \
       && ((x++))
   [ "$x" = 3 ] \
       && echo -e "\033[35m:: Welcome to your project: $name.\033[0m"
}

function see-pdf-file {
    check-for-latex-directory
    filename="$(conf-info-extract "project_name")"
    [ -z "$filename" ] && echo -e "\033[33m:: Project name not found in .conf file.\033[0m" && exit
    [ -e "$(echo $filename.pdf)" ] \
	&& zathura "$filename".pdf \
	    || echo -e "\033[33m:: PDF file \033[36m$filename.pdf\033[33m not found.\033[0m" 
}

function project-info {
    check-for-latex-directory
    bat -Ppf -l conf ./project.conf
}

function show-help {
    echo hi
}

function set-tex-file {
    check-for-latex-directory
    ./set.sh "$1"
}

function count-all {
    filename="$(conf-info-extract "project_name")"
    echo -e "\033[32m:: TeX file stats: $(texcount -1 -utf8 -ch -q "$filename".tex)\033[0m"
    echo -e "\033[32m:: Bib file stats: $(grep "@" refs.bib | wc -l) entries\033[0m"
}

check-dependencies
[ -z "$1" ] && list-project-files && exit
comd="$1"

case "$comd" in
    "create") create "$2" ;;
    "see") see-pdf-file ;;
    "set") set-tex-file "$2" ;;
    "help") ;;
    "count") count-all ;;
    "info") project-info ;;
    *) echo -e "\033[33m:: Unrecognized command.\033[0m" ;;
esac

