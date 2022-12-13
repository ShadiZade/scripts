#!/bin/bash

pdftk "$1" cat 2-end output .temp-"$1"-uncovered.pdf
rt "$1"
magick "$2" .temp-"$2"-cover.pdf
pdftk .temp-"$2"-cover.pdf .temp-"$1"-uncovered.pdf cat output "$1"
rt .temp-"$2"-cover.pdf .temp-"$1"-uncovered.pdf

# dependencies: pdftk, trashf, imagemagick
# changes the cover of a pdf file
# takes 2 agruments:
# chcover [pdf file] [cover image]
