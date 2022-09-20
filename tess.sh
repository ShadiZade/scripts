#!/bin/bash

cd ~/Motif/motif-projects/"$1"/burst/out &&
trash-put cache &&
ls -1 "$PWD"/* > tess-list.txt
tesseract tess-list.txt out -l eng pdf
mv out.pdf ~/Motif/motif-projects/"$1"/"$1"-output.pdf

# Takes one argument
# tess [name of project]
