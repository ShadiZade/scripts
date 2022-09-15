#!/bin/sh

# Use this for FCITX5
cim=$(qdbus "org.fcitx.Fcitx5" "/controller" "org.fcitx.Fcitx.Controller1.CurrentInputMethod")


case $cim in 
		keyboard-us) echo "en" 
			;;
		keyboard-ara) echo "ar" 
			;;
		keyboard-ru) echo "ru"
			;;
		pinyin) echo "zh"
			;;
esac


		

