#!/bin/bash
source ~/Repositories/scripts/essential-functions

music_composer="$(ls -1 ~/Misc/Backups/my-music/classical | sed 's|-works.txt||g' | rofi -normalize-match -dmenu -i -p "choose composer")"
[[ -z "$music_composer" ]] && exit
sane "$music_composer"
composer_file="$HOME/Misc/Backups/my-music/classical/$music_composer-works.txt"
sane "$composer_file"
chosen_title="$(cat "$composer_file" | awk -F ' — ' '{print $1}' | sort | uniq -c | sed 's/      1 //g;s/^      . /→ /' | rofi -normalize-match -dmenu -i -p 'choose piece' | sed 's/→ //g')"
[[ -z "$chosen_title" ]] && exit
sane "$chosen_title"
mov_q="$(cat "$composer_file" | grep "$chosen_title" | wc -l)"
sane "$mov_q"
[[ "$mov_q" -gt 1 ]] && {
    chosen_mov="$(cat "$composer_file" | grep "$chosen_title" | awk -F ' — ' '{print $2}' | sed -e 's/^$/0–Full piece/;s/^Overture. /00–&/;s/^I. /1–&/;s/^II. /2–&/;s/^III. /3–&/;s/^IV. /4–&/;s/^V. /5–&/;s/^VI. /6–&/;s/^VII. /7–&/;s/^VIII. /8–&/;s/^IX. /9–&/;s/^X. /10–&/;s/^XI. /11–&/;s/^XII. /12–&/;s/^XIII. /13–&/;s/^XIV. /14–&/;s/^XV. /15–&/;s/^XVI. /16–&/;s/^XVII. /17–&/;s/^XVIII. /18–&/;s/^XIX. /19–&/;s/^XX. /20–&/;s/^XXI. /21–&/;s/^XXII. /22–&/;s/^XXIII. /23–&/;s/^XXIV. /24–&/;s/^XXV. /25–&/;s/^XXVI. /26–&/;s/^XXVII. /27–&/;s/^XXVIII. /28–&/;s/^XXIX. /29–&/;s/^XXX. /30–&/;s/^XXXI. /31–&/;s/^XXXII. /32–&/;s/^XXXIII. /33–&/;s/^XXXIV. /34–&/;s/^XXXV. /35–&/;s/^XXXVI. /36–&/;s/^XXXVII. /37–&/;s/^XXXVIII. /38–&/;s/^XXXIX. /39–&/' | sort -V | sed 's/^.*–//g' | rofi -normalize-match -dmenu -i -p "$chosen_title")"
    # highest known movement number is 39 for Die Jahreszeiten, Hob.XXI:3 (Haydn, Joseph)
    sane "\"$chosen_title — $chosen_mov\""
    [[ "$chosen_mov" = "Full piece" ]] && {
	quodlibet --enqueue="\"$chosen_title\""
    } || {
	quodlibet --enqueue="\"$chosen_title — $chosen_mov\""
    }
} || {
    quodlibet --enqueue="\"$(grep "$chosen_title" "$composer_file")\""
}
