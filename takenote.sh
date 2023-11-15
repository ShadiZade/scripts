#!/bin/bash

function createfile {
    touch markdown-topic-"$1".md
    echo -e "\033[33m:: File \033[32mmarkdown-topic-"$1".md\033[33m created.\033[0m"
}

 
function setquiet {
    isol="$(name-isolator "$ifile")"
    echo -e "\033[33m:: Setting document...\033[0m"
    pandoc "$ifile" -o document-topic-"$isol".pdf
    echo -e "\033[33m:: Setting slideshow...\033[0m"
    pandoc "$ifile" -t beamer -o slideshow-topic-"$isol".pdf
}

function setboth {
    setquiet "$ifile"
    read -r -p ":: Open document or slideshow? [d/s] " w_doc
    [[ "$w_doc" = "d" ]] && zathura document-topic-"$isol".pdf
    [[ "$w_doc" = "s" ]] && zathura slideshow-topic-"$isol".pdf
}

function setdocument {
    isol="$(name-isolator "$ifile")"
    echo -e "\033[33m:: Setting document...\033[0m"
    pandoc "$ifile" -o document-topic-"$isol".pdf
    zathura document-topic-"$isol".pdf
}

function setslideshow {
    isol="$(name-isolator "$ifile")"
    echo -e "\033[33m:: Setting slideshow...\033[0m"
    pandoc "$ifile" -t beamer -o slideshow-topic-"$isol".pdf
    zathura slideshow-topic-"$isol".pdf
}

function name-isolator {
    echo "$1" | awk -F 'markdown-topic-' '{print $NF}' | awk -F '.' '{print $1}'
}

while getopts "sdbqc:i:" opt; do
  case $opt in
    i)
	ifile="$OPTARG"
	;;
    c)
	createfile "$OPTARG"
	;;
    b) 
	setboth "$ifile"
	;;
    q)
	setquiet "$ifile"
	;;
    d)
	setdocument "$ifile"
	;;
    s)
	setslideshow "$ifile"
	;;
    \?)
      echo "Invalid option: -$OPTARG"
      ;;
    :)
      echo "Option -$OPTARG requires an argument."
      ;;
  esac
done
