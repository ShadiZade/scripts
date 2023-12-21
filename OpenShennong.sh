#!/bin/bash
#
#   神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农
#   神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农
#   神农                                                                                                                   神农
#   神农                                                                                                                   神农
#   神农                                                                                                                   神农
#   神农                                                                                                                   神农
#   神农                                                                                                                   神农
#   神农                                                                                                                   神农
#   神农        .d88888b.                          .d8888b. 888                                                            神农
#   神农       d88P" "Y88b                        d88P  Y88b888                                                            神农
#   神农       888     888                        Y88b.     888                                                            神农
#   神农       888     88888888b.  .d88b. 88888b.  "Y888b.  88888b.  .d88b. 88888b. 88888b.  .d88b. 88888b.  .d88b.        神农
#   神农       888     888888 "88bd8P  Y8b888 "88b    "Y88b.888 "88bd8P  Y8b888 "88b888 "88bd88""88b888 "88bd88P"88b       神农
#   神农       888     888888  88888888888888  888      "888888  88888888888888  888888  888888  888888  888888  888       神农
#   神农       Y88b. .d88P888 d88PY8b.    888  888Y88b  d88P888  888Y8b.    888  888888  888Y88..88P888  888Y88b 888       神农
#   神农        "Y88888P" 88888P"  "Y8888 888  888 "Y8888P" 888. 888 "Y8888 888  888888  888 "Y88P" 888  888 "Y88888       神农
#   神农                  888                                                                                    888       神农
#   神农                  888                                                                               Y8b d88P       神农
#   神农                  888                            OpenShennong                                        "Y88P"        神农
#   神农                                             LaTeX Project Manager                                                 神农
#   神农                                                                                                                   神农
#   神农                                                                                                                   神农
#   神农                                                                                                                   神农
#   神农                                                                                                                   神农
#   神农                                                                                                                   神农
#   神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农
#   神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农神农
#

data_dir="$XDG_DATA_HOME/OpenShennong"
projects_csv="$data_dir/projects.csv"

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

function goto-project {
    # doesn't work, more fucking subshell bullshit again.
    [ "$(cat "$projects_csv" | wc -l)" = 0 ] \
	&& echo -e "\033[33m:: No projects in local data file.\033[0m" \
	&& exit
    intended_target="$(xsv select 1 "$projects_csv" | fzf)"
    [ -z "$intended_target" ] \
	&& echo -e "\033[33m:: Nothing selected.\033[0m" \
	&& exit
    cd "$(grep "^$intended_target," "$projects_csv" | xsv select 2)" \
	&& echo -e "\033[32m:: Welcome to \033[36m$intended_target\033[32m at \033[36m$(pwd)\033[32m.\033[0m" \
	&& list-project-files \
		|| echo -e "\033[33m:: Failed to go to \033[36m$intended_target\033[33m.\033[0m"
}


function list-project-files {
    runcase-dealer not F
    case $runcase in
	1) case "$1" in
	       "year") ;;
	       *) eza -l --icons --no-user --time-style=iso --sort=newest --color-scale all && exit ;;
	   esac
	   ;;
	2) eza -l --icons --no-user --time-style=iso --sort=newest --color-scale all && exit ;;
# 	F) goto-project ;;
	0) runcase-dealer only 0
	   eza -l --icons --no-user --time-style=iso --sort=modified --color-scale all --color=always \
	       --group-directories-first --no-quotes --no-permissions --git -I "*log|*aux|*toc|*conf|*blg|*bbl|set.sh" ;;
	*) echo -e "\033[33:: list-project-files: Unknown runcase.\033[0m" && exit ;;
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
	    [ "$runcase" != "$2" ] && echo -e "\033[33m:: Can’t do that in this directory (only $2).\033[0m" && exit ;;
	
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

function save-to-local {
    runcase-dealer only 0
    project_name="$(conf-info-extract project_name)"
    project_dir="$(conf-info-extract project_dir)"
    [ ! -e "$data_dir" ] && mkdir "$data_dir"
    touch "$projects_csv"
    grep "$project_dir" "$projects_csv" && exit
    echo "$project_name,$project_dir" >> "$projects_csv" \
	&&  echo -e "\033[32m:: Project recorded at "$data_dir"\033[0m"
}

function remove-from-local {
    # $1 should be a project_dir
    [ ! -e "$projects_csv" ] && mkdir "$data_dir"
    touch "$projects_csv"
    [ ! "$(grep "$1" "$projects_csv")" ] \
	&& echo -e "\033[33m:: Project not recorded at "$data_dir"\033[0m" \
	&& exit
    old_project_dir="$1"
    grep -v "$old_project_dir$" "$projects_csv" > "$projects_csv".temp
    mv "$projects_csv".temp "$projects_csv" \
	&& echo -e "\033[32m:: Project removed from "$data_dir"\033[0m"
}

function check-dependencies {
    dependencies=("xelatex" "bibtex" "eza" "fd" "zathura" "texcount" "xsv")
    # continue this later    
}

# interactive functions
function create {
    runcase-dealer only F
    [ -z "$1" ] \
	&& echo -e "\033[33m:: Please enter project name.\033[0m" \
	&& exit
    fd -q "^$1$" \
	&& echo -e "\033[33m:: Clobber prevented. Choose a different name.\033[0m" \
	&& exit
    xsv select 1 "$projects_csv" | grep -q "$1" \
	&& echo -e "\033[33m:: \033[36m$1\033[33m already exists. Choose a different name.\033[0m" \
	&& exit
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
	&& save-to-local \
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

function pdfgrep-term-freq {
    runcase-dealer only 0
    [ -z "$1" ] \
	&& echo -e "\033[33m:: Please enter a search term.\033[0m"
    echo "$1" | grep -q '/' \
	&& echo -e "\033[33m:: Lookup term cannot contain /.\033[0m" \
	&& exit
    lookup_file="./.lookups/lookup.$1.shennong"
    fd -qu lookup."$1".shennong ./.lookups \
	&& echo -e "\033[32m:: Previous lookup found!\033[0m" \
	&& bat -p "$lookup_file" \
	&& exit
    echo -e "\033[32m:: Working...\033[0m"
    pdfgrep --color=always -ic "$1" papers/* \
	| sed '/0$/d;s/:/,/g' \
	| xsv select 2,1 2>/dev/null \
	| sort -V \
	| tac \
	      > "$lookup_file"
    [ "$(cat "$lookup_file" | wc -l)" -eq 0 ] \
	&& echo -e "\033[33m:: No results found!\033[0m" > "$lookup_file"
    bat -p "$lookup_file"
}

function project-info {
    runcase-dealer only 0
    bat -Ppf -l conf ./project.conf
}

function show-help {
    echo -e " \
    Available commands: \n\
    \t\033[37mcreate\033[0m: Creates a new project.  \n\
    \t\033[37msee\033[0m: Views the project’s PDF file.\n\
    \t\033[37mset\033[0m: Sets the project’s TeX file using XeTeX. \033[37m[1, 3, N/A]\033[0m\n\
    \t\033[37mhelp\033[0m: Shows this help message. \n\
    \t\033[37mcount\033[0m: Counts lines and entries in the project’s TeX and BiB files. \n\
    \t\033[37minfo\033[0m: Shows the project’s info from the project.conf file. \n\
    \t\033[37mdl\033[0m: Downloads paper from sci-hub by DOI number. \n\
    \t\033[37manchor\033[0m: CURRENTLY NON-FUNCTIONAL \n\
    \t\033[37mrename\033[0m: Renames directory and/or project."
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
    runcase-dealer only 1
    echo -e "\033[32m:: Starting...\033[0m"
    [ -z "$1" ] \
	&& echo -e "\033[33m:: No DOI entered.\033[0m" \
	&& exit
    indoi="$(echo "$1" | sed 's|https://doi.org/||')" \
	&& echo -e "\033[32m:: DOI is \033[36m$indoi\033[0m"
    shurl="$(curl -s "https://sci-hub.ru/$indoi")" \
	&& echo -e "\033[32m:: Sci-Hub queried!\033[0m"
    ddurl="$(echo "$shurl" | grep -i 'pdf" src' | awk -F 'src="' '{print $2}' | awk -F '#' '{print $1}' | tr -d "\n")"
    ddurl="$(echo "$ddurl" | sed 's|^/downloads|sci-hub.ru/downloads|;s|^/uptodate|sci-hub.ru/uptodate|')"
    ddurl="$(echo "$ddurl" | sed 's|^/tree|sci-hub.ru/tree|;s|//||')"
    [[ -z "$2" ]] \
	&& bibname="unnamed" \
	    || bibname="$2"
    fd -q "$bibname".pdf \
	&& echo -e "\033[33m:: Paper \033[36m$bibname\033[33m already exists.\033[0m" \
	&& exit
    [[ -z "$ddurl" ]] \
	&& echo -e "\033[33m:: No file found in Sci-Hub.\033[0m" \
	&& exit
    wget -nc -O ./"$bibname".pdf -t 0 -- https://"$ddurl" && touch -c ./"$bibname".pdf
}

function rename-stuff {
    runcase-dealer only 0
    [ -z "$1" ] && echo -e "\033[33m:: rename-stuff: No valid command.\033[0m" && exit
    [ -z "$2" ] && echo -e "\033[33m:: rename-stuff: No valid parameter.\033[0m" && exit
    function rename-directory {
	current_name="$(pwd | awk -F '/' '{print $NF}')"
	cd ..
	mv -n "$current_name" "$1" || echo -e "\033[33m:: Move failed. Probably clobber.\033[0m"
	cd "$1" || exit
    }
    case "$1" in
	"dir")
	    project_name="$(conf-info-extract project_name)"
	    project_dir="$(conf-info-extract project_dir)"
	    remove-from-local "$project_dir"
	    rename-directory "$2"
	    sed -i "s|$project_dir|$(pwd)|g" ./project.conf
	    save-to-local
	    echo -e "\033[32m:: Directory renamed to $2"
	    ;;
	"project")
	    project_name="$(conf-info-extract project_name)"
	    project_dir="$(conf-info-extract project_dir)"
	    remove-from-local "$project_dir"
	    rename -va "$project_name" "$2" ./*
	    rename-directory "$2"
	    runcase-dealer only 0
	    sed -i "s|project_name = $project_name|project_name = $2|g" ./project.conf
	    sed -i "s|project_dir = $project_dir|project_dir = $(pwd)|g" ./project.conf
	    sed -i "s|project_name=\"$project_name\"|project_name=\"$2\"|g" ./set.sh
	    save-to-local
	    echo -e "\033[32m:: Project renamed to $2"
	    ;;
	*)
	    echo -e "\033[33m:: Unknown runcase-dealer command.\033[0m" ;;
    esac
    
	
}


check-dependencies
[ -z "$1" ] && list-project-files && exit
comd="$1"

case "$comd" in
    "create") create "$2" ;;
    "see") see-pdf-file ;;
    "set") set-tex-file "$2" ;;
    "help") show-help;;
    "count") count-all ;;
    "info") project-info ;;
    "dl") download-paper "$2" "$3" ;;
    "ls") list-project-files "$2" ;;
    "anchor") save-to-local ;;
    "rename") rename-stuff "$2" "$3" ;;
    "lookup") pdfgrep-term-freq "$2" ;;
    *) echo -e "\033[33m:: Unrecognized command.\033[0m" ;;
esac

