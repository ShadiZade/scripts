#!/bin/bash
# a script that rivals the "genius" of modern English-language poets by inserting random linebreaks into any block of text.
# this is literally better than any work of English-language free verse "poetry", ever.
# gaze upon sublime Arabic poetry and weep, Angloids, weep for your bastard language which lies in ruin.
#
# usage: ./poetryizer [text file to be turned into objectively superior poetry to Rupi Kaur's] [level of coherence]
#
cp $1 ".$1-temp"
word_count=$(cat $1 | wc -w)
coh="$2"
[ -z "$coh" ] && read -r -p ":: Enter level of coherence [1-100]: " coh
while [ "$word_count" -gt 0 ];
do i=$((1 + $RANDOM % $coh))
working_word=$(cat ".$1-temp" | awk -F ' ' '{print $1}')
if [ $i == 1 ]; then
poem=$(printf "$poem\n$working_word")
else
poem=$(printf "$poem $working_word")
fi
sed -i "s/^$working_word //g" ".$1-temp"
word_count=$((word_count-1))
done
printf "$poem" > "$1"-poem.txt
sed -i 's/^ //g' "$1"-poem.txt
cat "$1"-poem.txt
rm ".$1-temp"


