#!/bin/bash

bspwm_theme=pinestone-grey

# themes
### paprika-purple
### frontier-blue
### pinestone-grey

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

bspwm_theme_color_pinestone_grey="2f322b"
bspwm_theme_color_pinestone_white="acab8c"
bspwm_theme_color_mountain_ash="1d2321"
bspwm_theme_color_overcast_blue="7e99a0"


# definitions
case $bspwm_theme in
			"paprika-purple")
				bspwm_theme_primary_color=$bspwm_theme_color_paprika_purple
				bspwm_theme_secondary_color=$bspwm_theme_color_dignified_beige
				bspwm_theme_dark_color=$bspwm_theme_color_dark_paprika_purple
				bspwm_theme_alert_color=$bspwm_theme_color_deep_purple
				bspwm_theme_wallpaper="/usr/share/wallpapers/use/essence-2.png"
				;;
			"frontier-blue")
				bspwm_theme_primary_color=$bspwm_theme_color_frontier_blue
				bspwm_theme_secondary_color=$bspwm_theme_color_mountainside_redwhite
				bspwm_theme_dark_color=$bspwm_theme_color_dark_frontier_blue
				bspwm_theme_alert_color=$bspwm_theme_color_wispy_pink
				bspwm_theme_wallpaper="/usr/share/wallpapers/use/the-frontier.jpg"
				;;
			"pinestone-grey")
				bspwm_theme_primary_color=$bspwm_theme_color_pinestone_grey
				bspwm_theme_secondary_color=$bspwm_theme_color_pinestone_white
				bspwm_theme_dark_color=$bspwm_theme_color_mountain_ash
				bspwm_theme_alert_color=$bspwm_theme_color_overcast_blue
				bspwm_theme_wallpaper="/usr/share/wallpapers/use/go7-casson-white-pine.jpg"
				;;
esac


# how to add new themes
# 1) add theme name in themes section of this file with three sharps and a space
# 2) define colors and wallpaper in colors section of this file
# 3) bind colors in definitions section of this file
# 4) create rofi theme .rasi file with the same name as theme here
# 5) define colors in polybar config.ini file

# this script changes:
# in bspwm's bspwmrc: border color and wallpaper
# in rofi's config.rasi: theme name
# in polybar's config.ini: color definitions
#
# in the lockscreen script: the color flags
