#!/bin/bash

# non-interactive functions
function conf-info-extract {
    runcase-dealer only 0
    cat project.conf | grep "^$1 = " | awk -F ' = ' '{print $NF}'
}

function anchor-project {
    # manually define project_dir. This is a massive bodge.
    # does not work. variables don’t export out.
    runcase-dealer only 0
    export PROJECT_NAME="$(conf-info-extract project_name)"
    export PROJECT_DIR="$(conf-info-extract project_dir)"
    export ANCHOR_DONE="1"
}

function list-project-files {
    runcase-dealer not F
    case $runcase in
	1) eza -l --icons --no-user --time-style=iso --sort=newest --color-scale all && exit ;;
	2) eza -l --icons --no-user --time-style=iso --sort=newest --color-scale all && exit ;;
	*) runcase-dealer only 0
	   eza -l --icons --no-user --time-style=iso --sort=modified --color-scale all --color=always \
	       --group-directories-first --no-quotes --no-permissions --git -I "*log|*aux|*toc|*conf|*blg|*bbl|set.sh" ;;
    esac
}

function runcase-determiner {
    # runcase F is when there's no TeX project in sight
    # runcase 0 is the main TeX project
    # runcase 1 is the project/papers dir
    # runcase 2 is the project/images dir
    #
    # to define other runcases, add another other-runcases definition in this
    # function, and a goto location in runcase-dealer goto
    #
    fd -q -d 1 "project.conf" && export runcase="0" || export runcase="F"
    function other-runcases {
	[ -z "$1" ] && echo -e "\033[33m:: other-runcases: No search term for definition.\033[0m" && exit
	[ -z "$1" ] && echo -e "\033[33m:: other-runcases: No runcase number for definition.\033[0m" && exit
	if [ "$(pwd | awk -F '/' '{print $NF}')" = "$1" ]; then
	    fd -q -d 1 "project.conf" .. && export runcase="$2"
	fi
    }
    other-runcases papers 1
    other-runcases images 2
}

function runcase-dealer {
    runcase-determiner
    [ -z "$1" ] && echo -e "\033[33m:: runcase-dealer: No valid command.\033[0m" && exit
    [ -z "$2" ] && echo -e "\033[33m:: runcase-dealer: No valid parameter.\033[0m" && exit
    case "$1" in
	"only") 
	    [ "$runcase" != "$2" ] && echo -e "\033[33m:: Can’t do that in this directory.\033[0m" && exit ;;
	
	"not")
	    [ "$runcase" = "$2" ] && echo -e "\033[33m:: Can’t do that in this directory.\033[0m" && exit ;;
	
	"goto")
	    # doesn't work. anchor function problem.
	    [ -z "$ANCHOR_DONE" ] && echo -e "\033[33m:: Please anchor project first.\033[0m" && exit
	    case "$2" in
		0) cd "$PROJECT_DIR" ;;
		1) cd "$PROJECT_DIR"/papers ;;
		2) cd "$PROJECT_DIR"/images ;;
		*) echo -e "\033[33m:: runcase-dealer: unknown runcase.\033[0m" && exit ;;
	    esac
	    ;;
	*)
	    echo -e "\033[33m:: Unknown runcase-dealer command.\033[0m" ;;
    esac
}
function check-dependencies {
    dependencies=("xelatex" "bibtex" "eza" "fd" "zathura" "texcount")
    # continue this later    
}

# interactive functions
function create {
    runcase-dealer only F
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
   echo -e "project_dir = $(pwd)" >> project.conf
   [ "$x" = 2 ] \
       && xelatex -interaction=batchmode ./"$name".tex \
       && echo -e "\033[32m:: LaTeX files initialized.\033[0m" \
       && ((x++))
   [ "$x" = 3 ] \
       && echo -e "\033[35m:: Welcome to your project: $name.\033[0m"
}

function see-pdf-file {
    runcase-dealer only 0
    filename="$(conf-info-extract "project_name")"
    [ -z "$filename" ] && echo -e "\033[33m:: Project name not found in .conf file.\033[0m" && exit
    [ -e "$(echo $filename.pdf)" ] \
	&& zathura "$filename".pdf \
	    || echo -e "\033[33m:: PDF file \033[36m$filename.pdf\033[33m not found.\033[0m" 
}

function project-info {
    runcase-dealer only 0
    bat -Ppf -l conf ./project.conf
}

function show-help {
    echo hi
}

function set-tex-file {
    runcase-dealer only 0
    ./set.sh "$1"
}

function count-all {
    runcase-dealer only 0
    filename="$(conf-info-extract "project_name")"
    echo -e "\033[32m:: TeX file stats: $(texcount -1 -utf8 -ch -q "$filename".tex)\033[0m"
    echo -e "\033[32m:: Bib file stats: $(grep "@" refs.bib | wc -l) entries\033[0m"
}

function download-paper {
    runcase-dealer only 0
    fd -q -d 1 papers || echo -e "\033[33m:: No papers directory.\033[0m"
    fd -q -d 1 papers || exit
    echo -e "\033[32m:: Starting...\033[0m"
    [ -z "$1" ] && echo -e "\033[33m:: No DOI entered.\033[0m" && exit
    indoi="$(echo "$1" | sed 's|https://doi.org/||')" && echo -e "\033[32m:: DOI is \033[36m$indoi\033[0m"
    shurl="$(curl -s "https://sci-hub.ru/$indoi")" && echo -e "\033[32m:: Sci-Hub queried!\033[0m"
    ddurl="$(echo "$shurl" | grep -i 'pdf" src' | awk -F 'src="' '{print $2}' | awk -F '#' '{print $1}' | tr -d "\n")"
    ddurl="$(echo "$ddurl" | sed 's|^/downloads|sci-hub.ru/downloads|;s|^/uptodate|sci-hub.ru/uptodate|')"
    ddurl="$(echo "$ddurl" | sed 's|^/tree|sci-hub.ru/tree|;s|//||')"
    [[ -z "$2" ]] && bibname="unnamed" || bibname="$2"
    [[ -z "$ddurl" ]] && echo -e "\033[33m:: No file found in Sci-Hub!\033[0m"
    [[ -z "$ddurl" ]] && exit
    wget -nc -O ./papers/"$bibname".pdf -t 0 -- https://"$ddurl" && touch -c ./papers/"$bibname".pdf
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
    "dl") download-paper "$2" "$3" ;;
    "anchor") anchor-project ;;
    *) echo -e "\033[33m:: Unrecognized command.\033[0m" ;;
esac

