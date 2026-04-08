#!/bin/bash
source ~/Repositories/scripts/essential-functions

function sort-roman {
    # highest known movement number is 114 for 114 Songs (Ives)
    sed -e 's/^$/0000–Full piece/;s/^Overture\./000–&/;s/^Prelude\./00–&/;s/^Intro\./0–&/;s/^Epilogue\./99999–&/;s/^Coda\./999999–&/;s/^Nil\./99999–&/;s/^I\./1–&/;s/^II\./2–&/;s/^III\./3–&/;s/^IV\./4–&/;s/^V\./5–&/;s/^VI\./6–&/;s/^VII\./7–&/;s/^VIII\./8–&/;s/^IX\./9–&/;s/^X\./10–&/;s/^XI\./11–&/;s/^XII\./12–&/;s/^XIII\./13–&/;s/^XIV\./14–&/;s/^XV\./15–&/;s/^XVI\./16–&/;s/^XVII\./17–&/;s/^XVIII\./18–&/;s/^XIX\./19–&/;s/^XX\./20–&/;s/^XXI\./21–&/;s/^XXII\./22–&/;s/^XXIII\./23–&/;s/^XXIV\./24–&/;s/^XXV\./25–&/;s/^XXVI\./26–&/;s/^XXVII\./27–&/;s/^XXVIII\./28–&/;s/^XXIX\./29–&/;s/^XXX\./30–&/;s/^XXXI\./31–&/;s/^XXXII\./32–&/;s/^XXXIII\./33–&/;s/^XXXIV\./34–&/;s/^XXXV\./35–&/;s/^XXXVI\./36–&/;s/^XXXVII\./37–&/;s/^XXXVIII\./38–&/;s/^XXXIX\./39–&/;s/^XL\./40–&/;s/^XLI\./41–&/;s/^XLII\./42–&/;s/^XLIII\./43–&/;s/^XLIV\./44–&/;s/^XLV\./45–&/;s/^XLVI\./46–&/;s/^XLVII\./47–&/;s/^XLVIII\./48–&/;s/^XLIX\./49–&/;s/^L\./50–&/;s/^LI\./51–&/;s/^LII\./52–&/;s/^LIII\./53–&/;s/^LIV\./54–&/;s/^LV\./55–&/;s/^LVI\./56–&/;s/^LVII\./57–&/;s/^LVIII\./58–&/;s/^LIX\./59–&/;s/^LX\./60–&/;s/^LXI\./61–&/;s/^LXII\./62–&/;s/^LXIII\./63–&/;s/^LXIV\./64–&/;s/^LXV\./65–&/;s/^LXVI\./66–&/;s/^LXVII\./67–&/;s/^LXVIII\./68–&/;s/^LXIX\./69–&/;s/^LXX\./70–&/;s/^LXXI\./71–&/;s/^LXXII\./72–&/;s/^LXXIII\./73–&/;s/^LXXIV\./74–&/;s/^LXXV\./75–&/;s/^LXXVI\./76–&/;s/^LXXVII\./77–&/;s/^LXXVIII\./78–&/;s/^LXXIX\./79–&/;s/^LXXX\./80–&/;s/^LXXXI\./81–&/;s/^LXXXII\./82–&/;s/^LXXXIII\./83–&/;s/^LXXXIV\./84–&/;s/^LXXXV\./85–&/;s/^LXXXVI\./86–&/;s/^LXXXVII\./87–&/;s/^LXXXVIII\./88–&/;s/^LXXXIX\./89–&/;s/^XC\./90–&/;s/^XCI\./91–&/;s/^XCII\./92–&/;s/^XCIII\./93–&/;s/^XCIV\./94–&/;s/^XCV\./95–&/;s/^XCVI\./96–&/;s/^XCVII\./97–&/;s/^XCVIII\./98–&/;s/^XCIX\./99–&/;s/^C\./100–&/;s/^CI\./101–&/;s/^CII\./102–&/;s/^CIII\./103–&/;s/^CIV\./104–&/;s/^CV\./105–&/;s/^CVI\./106–&/;s/^CVII\./107–&/;s/^CVIII\./108–&/;s/^CIX\./109–&/;s/^CX\./110–&/;s/^CXI\./111–&/;s/^CXII\./112–&/;s/^CXIII\./113–&/;s/^CXIV\./114–&/'
}

music_composer="$(ls -1 ~/Misc/Backups/my-music/classical | sed 's|-works.txt||g' | rofi -normalize-match -dmenu -no-custom -i -p "choose composer")"
[[ -z "$music_composer" ]] && exit
sane "$music_composer"
composer_file="$HOME/Misc/Backups/my-music/classical/$music_composer-works.txt"
sane "$composer_file"
chosen_title="$(cat "$composer_file" | awk -F ' — ' '{print $1}' | sort -V | uniq -c | sed 's/^/←/g;s/←      1 //g' | perl -pe 's|← *.*? |→ |' | rofi -normalize-match -dmenu -no-custom -i -p 'choose piece' | sed 's/→ //g')"
[[ -z "$chosen_title" ]] && exit
sane "$chosen_title"
mov_q="$(cat "$composer_file" | grep "$chosen_title" | wc -l)"
sane "$mov_q"
[[ "$mov_q" -gt 1 ]] && {
    chosen_mov="$(cat "$composer_file" <(echo -n "$chosen_title — 000–All in order") | grep "$chosen_title" | awk -F ' — ' '{print $2}' | sort-roman | sort -h | sort -V | sed 's/^.*–//g' | rofi -normalize-match -dmenu -no-custom -i -p "$chosen_title")"
    sane "\"$chosen_title — $chosen_mov\""
    case "$chosen_mov" in
	"Full piece") quodlibet --enqueue="\"$chosen_title\"" ;;
	"All in order")
	    IFS=$'\n'
	    sane 'Selecting all'
	    for j in $(cat "$composer_file" | grep "$chosen_title" | awk -F ' — ' '{print $2}' | sort-roman | sort -V | sed 's/^.*–//g')
	    do
		quodlibet --enqueue="\"$chosen_title — $j\""
	    done
	    unset IFS
	    ;;
	*) quodlibet --enqueue="\"$chosen_title — $chosen_mov\"" ;;
    esac
} || {
    quodlibet --enqueue="\"$(grep "$chosen_title" "$composer_file")\""
}
