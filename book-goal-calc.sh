#!/bin/bash

dNYE=$(date +"%j")	
hMN=$(date +"%H")
bP=$(calc "(trunc(((($dNYE*24)+$hMN)/168),2)-trunc(((($dNYE*24)+$hMN)/168),0))*100" | awk '{gsub(/^\s+|\s+$/,"")} {print $0}')
cB=$(calc "trunc(((($dNYE*24)+$hMN)/168),0)+1" | awk '{gsub(/^\s+|\s+$/,"")} {print $0}')
