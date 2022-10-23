#!/bin/bash

bspwm_theme=frontier-blue

# themes
### paprika-purple
### frontier-blue

# colors
bspwm_basic_color_white="ffffff"
bspwm_basic_color_black="000000"
bspwm_basic_color_neutral_grey="888888"
bspwm_basic_color_dark_grey="1f2a3e"

bspwm_theme_color_paprika_purple="85132d"
bspwm_theme_color_dignified_beige="c48e5c"
bspwm_theme_color_dark_paprika_purple="9c1635"
bspwm_theme_color_deep_purple="55007f"

bspwm_theme_color_frontier_blue="314664"
bspwm_theme_color_mountainside_redwhite="b89388"
bspwm_theme_color_dark_frontier_blue="1a2636"
bspwm_theme_color_wispy_pink="d8787b"


# definitions
case $bspwm_theme in
			"paprika-purple")
				bspwm_theme_primary_color=$bspwm_theme_color_paprika_purple
				bspwm_theme_secondary_color=$bspwm_theme_color_dignified_beige
				bspwm_theme_dark_color=$bspwm_theme_color_dark_paprika_purple
				bspwm_theme_alert_color=$bspwm_theme_color_deep_purple
				;;
			"frontier-blue")
				bspwm_theme_primary_color=$bspwm_theme_color_frontier_blue
				bspwm_theme_secondary_color=$bspwm_theme_color_mountainside_redwhite
				bspwm_theme_dark_color=$bspwm_theme_color_dark_frontier_blue
				bspwm_theme_alert_color=$bspwm_theme_color_wispy_pink
				;;
esac

# wallpaper
bspwm_theme_wallpaper="/usr/share/wallpapers/use/the-frontier.jpg"
#bspwm_theme_wallpaper="/usr/share/wallpapers/use/basil.png"
#bspwm_theme_wallpaper="/usr/share/wallpapers/use/essence-2.png"
#bspwm_theme_wallpaper="/usr/share/wallpapers/use/worldmap-2.png"
