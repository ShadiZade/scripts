#!/bin/bash

		
mkdir -p ~/Motif/motif-projects/"$1"/burst &&
cd ~/Motif/motif-projects/"$1" &&
cp "$2" ./"$1".pdf &&
cd burst &&
pdftk ../"$1".pdf burst &&
trash-put doc_data.txt &&
mogrify -colorspace RGB -alpha off -density 400 -format png *.pdf | pv &&
trash-put *.pdf

# Takes two arguments
# newmotif [name of new project] [path to PDF file]
