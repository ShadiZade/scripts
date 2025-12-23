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
source ~/Repositories/scripts/essential-functions
data_dir="$XDG_DATA_HOME/OpenShennong"
local_registry="$data_dir/projects.csv"

# non-interactive functions
function conf-info-extract {
    runcase-dealer only 0
    cat project.conf | grep "^$1 = " | awk -F ' = ' '{print $NF}'
}

function goto-project {
    # doesn't work, more fucking subshell bullshit again.
    [[ "$(cat "$local_registry" | wc -l)" = 0 ]] && {
	echolor yellow ":: No projects in local data file."
	return 1
    }
    intended_target="$(xsv select 1 "$local_registry" | fzf)"
    [[ -z "$intended_target" ]] && {
	echolor yellow ":: Nothing selected." 
	return 1
    }
    cd "$(grep "^$intended_target," "$local_registry" | xsv select 2)" \
	&& echolor green-neonblue ":: Welcome to ““$intended_target”” at ““$(pwd)””." \
	&& list-project-files \
		|| echolor yellow-neonblue ":: Failed to go to ““$intended_target””"
}

function list-project-files {
    runcase-dealer not F
    case $runcase in
	1) case "$1" in
	       "year") ;;
	       *) eza -lX --icons --no-user --time-style=iso --sort=newest --color-scale all && exit ;;
	   esac
	   ;;
	2) eza -lX --icons --no-user --time-style=iso --sort=newest --color-scale all && exit ;;
# 	F) goto-project ;;
	0) runcase-dealer only 0
	   eza -lX --icons --no-user --time-style=iso --sort=modified --color-scale all --color=always \
	       --group-directories-first --no-quotes --no-permissions --git -I "*log|*aux|*toc|*conf|*blg|*bbl|set.sh" ;;
	*) echolor yellow ":: list-project-files: Unknown runcase." && exit ;;
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
	[ -z "$1" ] && echolor yellow ":: other-runcases: No search term for definition." && exit
	[ -z "$1" ] && echolor yellow ":: other-runcases: No runcase number for definition." && exit
	if [ "$(pwd | awk -F '/' '{print $NF}')" = "$1" ]; then
	    fd -q -d 1 "project.conf" .. && export runcase="$2"
	fi
    }
    other-runcases papers 1
    other-runcases images 2
}

function runcase-dealer {
    runcase-determiner
    [[ -z "$1" ]] && {
	echolor yellow ":: runcase-dealer: No valid command."
	exit 1
    }
    [[ -z "$2" ]] && {
	echolor yellow ":: runcase-dealer: No valid parameter."
	exit 1
    }
    case "$1" in
	"only") [[ "$runcase" != "$2" ]] && {
		    echolor yellow ":: Can’t do that in this directory (only $2)."
		    exit 1
		} ;;
	"not")  [[ "$runcase" = "$2" ]] && {
		    echolor yellow ":: Can’t do that in this directory."
		    exit 1
		} ;;
	*)      echolor yellow ":: Unknown runcase-dealer command." ;;
	# "goto")
	#     # doesn't work. anchor function problem.
	#     [ -z "$ANCHOR_DONE" ] && echolor yellow ":: Please anchor project first." && exit
	#     case "$2" in
	# 	0) cd "$PROJECT_DIR" ;;
	# 	1) cd "$PROJECT_DIR"/papers ;;
	# 	2) cd "$PROJECT_DIR"/images ;;
	# 	*) echolor yellow ":: runcase-dealer: unknown runcase." && exit ;;
	#     esac
	#     ;;
    esac
}

function save-to-local {
    runcase-dealer only 0
    project_name="$(conf-info-extract project_name)"
    project_dir="$(conf-info-extract project_dir)"
    [[ ! -e "$data_dir" ]] && mkdir "$data_dir"
    touch "$local_registry"
    grep -q ",$project_dir$" "$local_registry" \
	&& echolor yellow-neonblue ":: A project with the path ““$project_dir”” already exists." \
	&& exit
    echo "$project_name,$project_dir" >> "$local_registry" \
	&&  echolor green ":: Project recorded at $data_dir"
}

function remove-from-local {
    # $1 should be a project_dir
    [[ ! -e "$local_registry" ]] && mkdir "$data_dir"
    touch "$local_registry"
    grep -q "$1" "$local_registry" || {
	echolor yellow ":: Project not recorded at $data_dir"
	return 1
    }
    old_project_dir="$1"
    grep -v "$old_project_dir$" "$local_registry" > "$local_registry".temp
    mv "$local_registry" "$local_registry"-$(date +%Y%m%d%H%M%S)
    mv "$local_registry".temp "$local_registry" \
	&& echolor green ":: Project removed from $data_dir"
}

function remove-from-local-prompt {
    [[ ! -e "$local_registry" ]] && mkdir "$data_dir"
    touch "$local_registry"
    selected_project="$(xsv select 1 "$local_registry" | fzf --prompt="Choose project to remove from local registry: ")"
    [[ -z "$selected_project" ]] && {
	echolor yellow ":: Nothing selected."
	return 1
    }
    echolor green-neonblue ":: Do you want to remove ““$selected_project”” from the local registry? (y/N) " 1
    read -r remove_p
    [[ "$remove_p" != "y" ]] && {
	echolor yellow ":: Nothing done."
	return 1
    }
    sed -i "/^$selected_project,/d" "$local_registry" \
	&& echolor green-neonblue ":: Project ““$selected_project”” removed from local registry."    
}

function show-local-registry {
    bat -Pn "$local_registry"
}

function update-project-info-file {
    runcase-dealer only 0
    project_name="$(conf-info-extract project_name)"
    project_dir="$(conf-info-extract project_dir)"
    [[ "$(pwd)" != "$project_dir" ]] && {
	sed -i "/^project_dir /d" project.conf 
	echo "project_dir = $(pwd)" >> project.conf 
	echolor green-neonblue ":: Old directory: ““$project_dir””" 
	echolor green-neonblue ":: New directory: ““$(pwd)””" 
	remove-from-local "$project_dir" 
	echolor green ":: Please run anchor again." 
    } || {
	echolor green ":: Project info already up-to-date."
    }
    # TODO: also add check for project name
    # TODO: add parameter in project.conf to indicate whether project is in local registry
    update-reading-notes-file
}

function update-reading-notes-file {
    runcase-dealer only 0
    for j in $(eza -1X "$(pwd)/papers")
    do
	grep -q "\[\[file:papers/$j\]" notes/reading-notes.org && continue
	echo "* [[file:papers/$j][${j/.pdf/}]]" >> notes/reading-notes.org
	echolor green-aquamarine ":: Added ““${j/.pdf/}”” to reading notes file!"
    done
    for j in $(eza -1X "$(pwd)/papers")
    do
	grep -q "\[\[file:papers/$j\]" notes/paper-summaries.org && continue
	echo "* [[file:papers/$j][${j/.pdf/}]]" >> notes/paper-summaries.org
	echolor pink-aquamarine ":: Added ““${j/.pdf/}”” to paper summaries file!"
    done    
}

function check-dependencies {
    dependencies=("texlive-xetex" "texlive-bibtexextra" "texlive-binextra" "eza" "fd" "sioyek" "xsv" "bat" "pdfgrep")
    # continue this later    
}

# interactive functions
function create {
    runcase-dealer only F
    [[ -z "$1" ]] && {
	echolor yellow ":: Please enter project name."
	return 1
    }
    fd -d 1 -q "^$1$" && {
	echolor yellow ":: Clobber prevented. Choose a different name."
	return 1
    }
    xsv select 1 "$local_registry" | grep -q "$1" && {
	echolor yellow-neonblue ":: ““$1”” already exists. Choose a different name." 
	return 1
    }
    name="$1"
    x=0
    cp -nr ~/Misc/templates/latex/ ./"$name" \
	&& echolor green ":: Template copied." \
   	    || echolor yellow ":: Template not copied."
    sed -i "s/REPLACEHERE/$name/g" ./"$name"/set.sh && ((x++))
    mv -n ./"$name"/template.tex ./"$name"/"$name".tex && ((x++))
    [[ "$x" = 2 ]] && echolor green ":: All parameters replaced." || echolor yellow ":: Not all parameters replaced."
    cd ./"$name" || exit
    echo -e "project_name = $name" >> project.conf
    echo -e "project_dir = $(pwd)" >> project.conf
    [[ "$x" = 2 ]] && {
	xelatex -interaction=batchmode ./"$name".tex
	echolor green ":: LaTeX files initialized."
	((x++))
    }
    [[ "$x" = 3 ]] && {
	save-to-local
	echolor purple-neonblue ":: Welcome to your project: ““$name.””"
    }
}

function see-pdf-file {
    runcase-dealer only 0
    filename="$(conf-info-extract "project_name")"
    [[ -z "$filename" ]] && {
	echolor yellow ":: Project name not found in .conf file."
	return 1
    }
    [[ -e "$filename.pdf" ]] && {
	( sioyek "$filename".pdf 2>/dev/null >/dev/null )
    } || {
	echolor yellow-neonblue ":: PDF file ““$filename.pdf”” not found."
    }
}

function pdfgrep-term-freq {
    runcase-dealer only 0
    [[ -z "$1" ]] && echolor yellow ":: Please enter a search term."
    echo "$1" | grep -q '/' && {
	echolor yellow ":: Lookup term cannot contain /." 
	return 1
    }
    lookup_file="./.lookups/lookup.$1.shennong"
    fd -qu lookup."$1".shennong ./.lookups && {
	echolor green ":: Previous lookup found! To refresh, use the 'relookup' command."
	bat -p "$lookup_file"
	return 1
    }
    echolor green ":: Working..."
    pdfgrep --color=always -ic "$1" papers/* \
	| sed '/0$/d;s/:/,/g' \
	| xsv select 2,1 2>/dev/null \
	| sort -V \
	| tac \
	      > "$lookup_file"
    [[ "$(cat "$lookup_file" | wc -l)" -eq 0 ]] && {
	echolor yellow ":: No results found!" > "$lookup_file"
    }
    bat -p "$lookup_file"
}

function pdfgrep-term-freq-again {
    runcase-dealer only 0
    [[ -z "$1" ]] && echolor yellow ":: Please enter a search term."
    echo "$1" | grep -q '/' && {
	echolor yellow ":: Lookup term cannot contain /."
	return 1
    }
    lookup_file="./.lookups/lookup.$1.shennong"
    [[ -e "$lookup_file" ]] && {
	echolor green ":: $(mv -nv "$lookup_file" "./.lookups/.archive/lookup.$1.$(date +%Y%m%d%H%M%S).shennong") "
    } || {
	echolor yellow ":: No such previous lookup."
    }
    pdfgrep-term-freq "$1"
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
    \t\033[37mcount\033[0m: Counts stats of the project’s TeX and BiB files. \n\
    \t\033[37minfo\033[0m: Shows the project’s info from the project.conf file. \n\
    \t\033[37mdl\033[0m: Downloads paper from sci-hub by DOI number. \n\
    \t\033[37manchor\033[0m: Save project path to local registry. \n\
    \t\033[37munanchor\033[0m: Remove project path from local registry. \n\
    \t\033[37mshowall\033[0m: Show all projects currently in local registry. \n\
    \t\033[37mrename\033[0m: Renames directory and/or project. \033[37m[project, dir]\033[0m\n \
    \t\033[37mlookup\033[0m: Uses pdfgrep to find search term in all papers. \n\
    \t\033[37mrelookup\033[0m: Ditto, but doesn’t resort to cached lookup files." 
}

function set-tex-file {
    runcase-dealer only 0
    ./set.sh "$1"
}

function count-all {
    runcase-dealer only 0
    filename="$(conf-info-extract "project_name")"
    blg_used="$(grep -i "You've used" "$filename".blg | awk -F ' ' '{print $3}')"
    bib_count="$(grep "@" refs.bib | wc -l)"
    allpapers=($(grep '@' refs.bib | awk -F '{' '{print $NF}' | sed 's/, *$//g'))
    i=0
    unused=0
    undownloaded=0
    commented=0
    rejected=0
    echolor green ":: These are your unused papers:"
    while [[ "$i" -le "${#allpapers[@]}" ]]; do
	thispaper="${allpapers[$i]}"
	filename="$(conf-info-extract "project_name")"
	((i++))
	grep -q "$thispaper" "$filename".bbl && continue
	undwarning=""
	if fd -q "^$thispaper".pdf ./papers/.rejected; then   
	    undwarning="\t\033[35m<-- REJECTED\033[0m"
	    ((rejected++))
	    continue
	fi
	if ! fd -d 1 -q "^$thispaper".pdf ./papers; then   
	    [[ -z "$undwarning" ]] && {
		undwarning=" \t\033[33m<--- UNDOWNLOADED\033[0m"
		((undownloaded++))
		((unused--))
	    } 
	fi
	if grep -qF "% ~\\ci{$thispaper}" "$filename".tex; then
	    [[ -z "$undwarning" ]] && {
		undwarning="\033[35m✓\033[0m"
	    } || {
		undwarning=" \t\033[33m<--- COMMENTED but UNDOWNLOADED\033[0m"
	    }
	    ((commented++))
	fi
	[[ -z "$undwarning" ]] && undwarning=" \t\033[34m<--- UNCOMMENTED\033[0m"
	echo -e "$thispaper $undwarning" && ((unused++))
    done
    allpapers=($(eza -1X ./papers | sed 's/\.pdf//g')) # reuse allpapers to list all pdfs
    i=0
    unbibbed=0
    while [[ "$i" -le "${#allpapers[@]}" ]]; do
	thispaper="${allpapers[$i]}"
	((i++))
	grep -q "$thispaper," refs.bib && continue
	echo -e "$thispaper \t\033[31m<--- UNBIBBED\033[0m"
	((unbibbed++))
    done
    echolor green-neonblue ":: Bib file stats: ““$bib_count”” entries: ““$blg_used”” in use, ““$unused”” unused (““$commented”” commented), ““$undownloaded”” undownloaded, ““$rejected”” rejected, and " 1
    echolor green-red "““$unbibbed”” unbibbed papers."
    allcalc=$((blg_used + unused + undownloaded + rejected - unbibbed))
    [[ "$allcalc" -ne "$bib_count" ]] && {
	echolor yellow-neonblue ":: Something went wrong. The sum ““$allcalc”” is different than the Bib file number ““$bib_count””."
    }
    echolor green-neonblue ":: TeX file stats: ““$(texcount -1 -utf8 -ch -q "$filename".tex)””"
}

function download-paper {
    echolor green ":: Starting PDF retrieval..."
    [[ -z "$1" ]] && {
	echolor red ":: No DOI entered."
	return 1
    }
    scimirror="ru"
    indoi="$(echo -n "$1" | sed 's|https://doi.org/||;s/\[/\\[/g;s/\]/\\]/g')"
    echolor green-neonblue ":: Going to ““https://sci-hub.$scimirror/$indoi””"
    extract-cookies
    shurl="$(curl --cookie "$COOKIE_FILE" -s "https://sci-hub.$scimirror/$indoi")"
    echolor green ":: Sci-Hub queried!"
    echo "$shurl" | grep -q "doesn't have the requested document" && {
	echolor yellow ":: Sci-Hub does not have this file."
	return 1
    }
    echo "$shurl" | grep -q "Checking your browser" && {
	echolor yellow ":: Caught in evil CAPTCHA hell. Please inform the website that you’re an honest researcher and retry."
	return 1
    }
    echo "$shurl" | grep -q "Error 5" && {
	echolor yellow ":: Server error on mirror ““.$scimirror””"
	return 1
    }
    ddurl="$(echo "$shurl" | grep -A 1 'class="download"' | tail -n 1 | awk -F 'href="' '{print $2}' | awk -F '"></a>' '{print $1}')"
    [[ -z "$2" ]] && bibname="unnamed" || bibname="$(kebab "$2")"
    [[ -s "$bibname".pdf ]] && {
	echolor yellow-neonblue ":: Paper ““$bibname”” already exists. Overwrite? (y/N) " 1
	read -r overwrite_p
	[[ "$overwrite_p" = y ]] && echolor green ":: $(rm -vf "$bibname".pdf)" || return 1
    }
    [[ -e "$bibname".pdf && ! -s "$bibname".pdf ]] && {
	echolor yellow-neonblue ":: Paper ““$bibname”” already exists with size zero. Overwriting automatically..."
	echolor green ":: $(rm -vf "$bibname".pdf)" || return 1
    }
    [[ -z "$ddurl" ]] && {
	echolor red ":: Unknown fatal error."
	return 1
    }
    wget --load-cookies "$COOKIE_FILE" -nc -O ./"$bibname".pdf -t 0 -- "https://sci-hub.$scimirror$ddurl" && touch -c ./"$bibname".pdf
}

function fetch-bib-citation {
    [[ -z "$1" ]] && return 1
    [[ -z "$EMAIL" ]] && {
	echolor red ":: Email variable not found. Exiting."
	return 1
    }
    hostile_websites=("sciencedirect.com" "jstor.org" "cabidigitallibrary.org" "ebscohost.com" "plos.org" "oup.com" "elibrary.ru")
    for j in ${hostile_websites[@]}
    do
	grep -q "$j" <<< "$1" && {
	    echolor red ":: Cannot fetch bib citation because ““$j”” is a hostile website."
	    return 1
	}
    done
    product_url="${1#/}"
    product_url="${product_url%/}"
    product_url="$(sed 's/\[/\\[/g;s/\]/\\]/g' <<< "$product_url")"
    tmp_bib="/tmp/tmp-bib-$(date-string)"
    echolor green ":: Starting bib retrieval..."
    echolor green-neonblue ":: Going to ““https://api.citeas.org/product/$product_url?email=$EMAIL””"
    extract-cookies
    curl --cookie "$COOKIE_FILE" -s "https://api.citeas.org/product/$product_url?email=$EMAIL" > "$tmp_bib-full"
    [[ "$(sed 1q "$tmp_bib-full")" = "<!DOCTYPE html>" ]] && {
	echolor red ":: Citation returned an HTML file. Exiting."
	return 1
    }
    sed -i 's/update-to/updateto/g' "$tmp_bib-full"
    jq -r '.metadata.updateto.[].type' "$tmp_bib-full" 2>/dev/null && {
	echolor red ":: Found ““$(jq -r '.metadata.updateto.[].type' "$tmp_bib-full")”” for this article!"
	echolor red ":: Continue? <return> " 1
	read -r
    }
    jq -r '.exports.[] | select( .export_name == "bibtex" ) | .export' "$tmp_bib-full" > "$tmp_bib"
    echolor green ":: Citeas.org queried!"
    sed -i 's/journal-article/article/g;s/book-chapter/incollection/g;s/,,/,/g;s/title={/title={{/g;s/title=/\ntitle=/g;/title=/s/}/}}/g' "$tmp_bib"
    sed -i 's/<i>//g;s|</i>||g' "$tmp_bib"
    doikey="$(jq -r '.metadata.DOI' "$tmp_bib-full")"
    [[ "$doikey" = "null" ]] && doikey=''
    function authorkey-filter {
	sed 's/al-//gi;s/al //gi;s/de /de/gi;s/den /den/gi;s/don /don/gi;s/van /van/gi;s/von /von/gi;s/le /le/gi;s/la /la/gi;s/les /les/gi'            \
	    | tr -d -- '-‐'                                                                                                                            \
	    | awk -F '{' '{print $2}'                                                                                                                  \
	    | awk -F '}' '{print $1}'                                                                                                                  \
	    | awk '{print $1}'                                                                                                                         \
	    | tr '[:upper:]' '[:lower:]'                                                                                                               \
	    | tr -d ','
    }
    function titlekey-filter {
	awk -F '{{' '{print $2}'                                                                                                                       \
	    | awk -F '}}' '{print $1}'                                                                                                                 \
	    | sed 's/<i>//g;s|</i>||g'                                                                                                                 \
	    | sed 's/[-‐—–]//g'                                                                                                                        \
	    | tr -d '[1234567890]'                                                                                                                     \
	    | kebab                                                                                                                                    \
	    | sed 's/-and-/-/;s/-or-/-/;s/^and-//;s/^or-//'                                                                                            \
	    | sed 's/-on-/-/;s/-who/-/;s/-why-/-/;s/-what-/-/;s/-when-/-/;s/-which-/-/;s/-how-/-/;s/-would-/-/;s/-some-/-/;s/-several-/-/'             \
	    | sed 's/-can-/-/;s/-do-/-/;s/-did-/-/;s/-does-/-/;s/-dont-/-/;s/-didnt-/-/;s/-doesnt-/-/;s/-is-/-/;s/-are-/-/;s/-will-/-/;s/-might-/-/'   \
	    | sed 's/-it-/-/;s/-he-/-/;s/-she-/-/;s/-his-/-/;s/-her-/-/;s/-they-/-/;s/-them-/-/;s/-their-/-/;s/-hers-/-/;s/-theirs-/-/'                \
	    | sed 's/-a-/-/;s/-an-/-/;s/-the-/-/;s/-i-/-/;s/-we-/-/;s/-they-/-/;s/-you-/-/;s/^to-//'                                                   \
	    | sed 's/-is-/-/;s/-was-/-/;s/-be-/-/;s/-being-/-/;s/-were-/-/;s/-werent-/-/;s/-wasnt-/-/;s/-isnt-/-/;s/-not-/-/'                          \
	    | sed 's/^on-//;s/^who//;s/^why-//;s/^what-//;s/^when-//;s/^which-//;s/^how-//;s/^would-//;s/^some-//;s/^several-//'                       \
	    | sed 's/^can-//;s/^do-//;s/^did-//;s/^does-//;s/^dont-//;s/^didnt-//;s/^doesnt-//;s/^is-//;s/^are-//;s/^will-//;s/^might-//'              \
	    | sed 's/^it-//;s/^he-//;s/^she-//;s/^his-//;s/^her-//;s/^they-//;s/^them-//;s/^their-//;s/^hers-//;s/^theirs-//'                          \
	    | sed 's/^a-//;s/^an-//;s/^the-//;s/^i-//;s/^we-//;s/^they-//;s/^you-//'                                                                   \
	    | sed 's/^is-//;s/^was-//;s/^be-//;s/^being-//;s/^were-//;s/^werent-//;s/^wasnt-//;s/^isnt-//;s/^not-//'                                   \
	    | sed 's/^here-//;s/^there-//;s/^where-//;s/^while-//;s/^whilst-//;s/^when-//;s/^whence-//;s/^then-//;s/^for-//'                           \
	    | awk -F '-' '{print $1}'
    }
    authorkey="$(grep 'author=' "$tmp_bib" | authorkey-filter)"
    titlekey="$( grep  'title=' "$tmp_bib" | titlekey-filter )"
    yearkey="$(grep 'year=' "$tmp_bib" | awk -F '{' '{print $2}' | awk -F '}' '{print $1}')"
    [[ -z "$authorkey" || -z "$yearkey" || -z "$titlekey" ]] && {
	echolor red ":: Missing results. Exiting.\n:: Author ““$authorkey””\n:: Year ““$yearkey””\n:: Title ““$titlekey””"
	echolor red ":: Full result\n““$(cat "$tmp_bib")””"
	return 1
    }
    bibkey="$(kebab $authorkey$yearkey$titlekey)"
    [[ "$bibkey" = "error" ]] && {
	echolor red ":: Citation returned error. Exiting."
	# this check is probably completely redundant
	return 1
    }
    sed -i "s/ITEM1/$bibkey/" "$tmp_bib"
    [[ ! -z "$doikey" ]] && {
	sed -i 's/}}$/},/g' "$tmp_bib"
	echo "doi={$doikey}}" >> "$tmp_bib"
    }
}

function fetch-bib-no-add {
    fetch-bib-citation "$1" || return 1
    bat -Ppl bib "$tmp_bib"
}

function add-bib-citation-to-refs {
    runcase-dealer only 1
    fetch-bib-citation "$1" || return 1
    grep -q "{$bibkey," ../refs.bib && {
	echolor red-neonblue ":: Article ““$bibkey”” already exists in refs.bib. Not adding."
    } || {
	bat -Ppl bib "$tmp_bib"
	cat "$tmp_bib" >> ../refs.bib
	echo >> ../refs.bib
    }
}
    
function get-bib-and-download-paper {
    runcase-dealer only 1
    add-bib-citation-to-refs "$1" || return 1
    [[ -z "$bibkey" ]] && {
	echolor red ":: Bibkey not found."
	return 1
    }
    echolor green-neonblue ":: Downloading paper as ““$bibkey””"
    echolor green-neonblue ":: Detected DOI as ““$doikey””"
    download-paper "${doikey:-$1}" "$bibkey"
}

function rename-stuff {
    runcase-dealer only 0
    [[ -z "$1" ]] && {
	echolor yellow ":: rename-stuff: No valid command."
	return 1
    }
    [[ -z "$2" ]] && {
	echolor yellow ":: rename-stuff: No valid parameter."
	return 1
    }
    function rename-directory {
	current_name="$(pwd | awk -F '/' '{print $NF}')"
	cd ..
	mv -n "$current_name" "$1" || echolor yellow ":: Move failed. Probably clobber."
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
	    echolor green-neonblue ":: Directory renamed to ““$2””"
	    ;;
	"project")
	    project_name="$(conf-info-extract project_name)"
	    project_dir="$(conf-info-extract project_dir)"
	    grep -q "^$2," "$local_registry" \
		&& echolor yellow ":: A project with that name already exists." \
		&& exit
	    remove-from-local "$project_dir"
	    rename -va "$project_name" "$2" ./*
	    rename-directory "$2"
	    runcase-dealer only 0
	    sed -i "s|project_name = $project_name|project_name = $2|g" ./project.conf
	    sed -i "s|project_dir = $project_dir|project_dir = $(pwd)|g" ./project.conf
	    sed -i "s|project_name=\"$project_name\"|project_name=\"$2\"|g" ./set.sh
	    save-to-local
	    echolor green-neonblue ":: Project renamed to ““$2””"
	    ;;
	*)
	    echolor yellow ":: Unknown runcase-dealer command." ;;
    esac
    
	
}


check-dependencies
[[ -z "$1" ]] && list-project-files && exit
comd="$1"

case "$comd" in
    "create") create "$2" ;;
    "see") see-pdf-file ;;
    "set") set-tex-file "$2" ;;
    "help") show-help;;
    "count") count-all ;;
    "info") project-info ;;
    "dl") get-bib-and-download-paper "$2" ;; # inside project
    "bib") add-bib-citation-to-refs "$2" ;;  # inside project
    "download") download-paper "$2" "$3" ;;  # outside project
    "citation") fetch-bib-no-add "$2" ;;     # outside project
    "ls") list-project-files "$2" ;;
    "anchor") save-to-local ;;
    "unanchor") remove-from-local-prompt ;;
    "showall") show-local-registry ;;
    "rename") rename-stuff "$2" "$3" ;;
    "lookup") pdfgrep-term-freq "$2" ;;
    "relookup") pdfgrep-term-freq-again "$2" ;;
    "update") update-project-info-file ;;
    *) echolor yellow ":: Unrecognized command." ;;
esac

