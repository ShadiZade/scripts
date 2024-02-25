#!/bin/sh
case $(qdbus "org.fcitx.Fcitx5" "/controller" "org.fcitx.Fcitx.Controller1.CurrentInputMethod") in 
		keyboard-us) echo "en" ;;
		keyboard-ara) echo "ar" ;;
		keyboard-ru) echo "ru" ;;
		pinyin) echo "zh" ;;
esac
