#!/bin/bash

pdftk "$1" cat 2-end output .temp-"$1"-uncovered.pdf
trash-put "$1"
magick "$2" .temp-"$2"-cover.pdf
pdftk .temp-"$2"-cover.pdf .temp-"$1"-uncovered.pdf cat output "$1"
trash-put .temp-"$2"-cover.pdf .temp-"$1"-uncovered.pdf

# takes 2 agruments:
# chcover [pdf file] [cover image]
