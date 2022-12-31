#!/bin/bash
hours_since_newyear=$(calc "(($(date +'%j')-1)*24)+$(date +'%k')")	
bP=$(calc "(trunc(($hours_since_newyear/168),2)-trunc(($hours_since_newyear/168),0))*100" | tr -d " ")
cB=$(calc "trunc(($hours_since_newyear/168),0)+1" | tr -d " ")
