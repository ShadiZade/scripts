#!/bin/bash
case $(qdbus "org.fcitx.Fcitx5" "/controller" "org.fcitx.Fcitx.Controller1.CurrentInputMethod") in 
    keyboard-us) echo "eng" ;;
    keyboard-ara) echo "ضـاد" | fribidi | awk '{gsub(/^\s+|\s+$/,"")} {print $0}';;
    keyboard-pt) echo "ção" ;;
    pinyin) echo "汉语" ;;
    zhengma-pinyin) echo "郑拼" ;;
esac
