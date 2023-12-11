#!/bin/bash

# one_book_per_x_days: defined in zsh/variables, reading goal set by user
obpxd=7

# books_since_january_1: exact reading progress
bsj1=$(R -s -e "((($(date +%j) - 1) * 24) + $(date +%k)) / ($obpxd * 24)" | awk -F "] " '{print $NF}')

# book_pages: percentage of book reached so far
bP=$(R -s -e "bsj <- $bsj1; bsj <- bsj - floor(bsj); round(bsj * 100)" | awk -F "] " '{print $NF}')

# current_book: No. of current book
cB=$(R -s -e "floor($bsj1) + 1" | awk -F "] " '{print $NF}')


### This is 14x slower than the existing script. Unsurprisingly.
