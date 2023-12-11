#!/bin/bash
source ~/Repositories/dotfiles/zsh/variables
# the user sets the $obpxd variable in the above file to decide their reading goal
div="$(calc "$obpxd * 24")" 
hours_since_newyear=$(calc "(($(date +'%j' | sed 's|^0*||g')-1)*24)+$(date +'%k' | sed 's|^0*||g')")	
# sed removes trailing zeroes, which mess up the calc command.
bP=$(calc "(trunc(($hours_since_newyear/$div),2)-trunc(($hours_since_newyear/$div),0))*100" | tr -d " ")
cB=$(calc "trunc(($hours_since_newyear/$div),0)+1" | tr -d " ")
# trunc here serves as a makeshift floor function. the decimal is extracted and calculated into a percentage.
