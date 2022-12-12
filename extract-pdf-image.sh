#!/bin/bash

qpdf "$1" --pages "$1" "$2" -- --split-pages ."$3".pdf
magick -density 150 ."$3"-1.pdf "$3".png
rt ."$3"-1.pdf


# get-image [original file] [# of desired page] [final name w/o ext]
#
# $1 = original pdf name
# $2 = page number
# $3 = target file name (without extension)
