#!/bin/bash

bspwm_theme=forestbeam-green

# colors & themes
bspwm_basic_color_white="ffffff"
bspwm_basic_color_black="000000"
bspwm_basic_color_neutral_grey="888888"
bspwm_basic_color_dark_grey="1f2a3e"

### paprika-purple
bspwm_theme_color_paprika_purple="85132d"
bspwm_theme_color_dignified_beige="c48e5c"
bspwm_theme_color_dark_paprika_purple="9c1635"
bspwm_theme_color_deep_purple="55007f"

### frontier-blue
bspwm_theme_color_frontier_blue="314664"
bspwm_theme_color_mountainside_redwhite="b89388"
bspwm_theme_color_dark_frontier_blue="1a2636"
bspwm_theme_color_wispy_pink="d8787b"

### pinestone-grey
bspwm_theme_color_pinestone_grey="2f322b"
bspwm_theme_color_pinestone_white="acab8c"
bspwm_theme_color_mountain_ash="1d2321"
bspwm_theme_color_overcast_blue="7e99a0"

### collective-green
bspwm_theme_color_collective_green="2c4235"
bspwm_theme_color_monumental_gold="d7b57d"
bspwm_theme_color_dark_collective_green="1d2c23"
bspwm_theme_color_glorious_red="aa3b3d"

### industrial-black
bspwm_theme_color_industrial_black="201f27"
bspwm_theme_color_scaffolding_tan="9f773f"
bspwm_theme_color_light_industrial_black="302f3b"
bspwm_theme_color_banner_red="a41828"

### forestbeam-green
bspwm_theme_color_forestbeam_green="97b074"
bspwm_theme_color_autumnleaf_purple="391e27"
bspwm_theme_color_light_forestbeam_green="bedc90"
bspwm_theme_color_autumnleaf_yellow="bcae19"

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
			"collective-green")
				bspwm_theme_primary_color=$bspwm_theme_color_collective_green
				bspwm_theme_secondary_color=$bspwm_theme_color_monumental_gold
				bspwm_theme_dark_color=$bspwm_theme_color_dark_collective_green
				bspwm_theme_alert_color=$bspwm_theme_color_glorious_red
				bspwm_theme_wallpaper="/usr/share/wallpapers/use/collective-terrace.jpg"
				;;
			"industrial-black")
				bspwm_theme_primary_color=$bspwm_theme_color_industrial_black
				bspwm_theme_secondary_color=$bspwm_theme_color_scaffolding_tan
				bspwm_theme_dark_color=$bspwm_theme_color_light_industrial_black
				bspwm_theme_alert_color=$bspwm_theme_color_banner_red
				bspwm_theme_wallpaper="/usr/share/wallpapers/use/industrial-2058.jpg"
				;;
			"forestbeam-green")
				bspwm_theme_primary_color=$bspwm_theme_color_forestbeam_green
				bspwm_theme_secondary_color=$bspwm_theme_color_autumnleaf_purple
				bspwm_theme_dark_color=$bspwm_theme_color_light_forestbeam_green
				bspwm_theme_alert_color=$bspwm_theme_color_autumnleaf_yellow
				bspwm_theme_wallpaper="/usr/share/wallpapers/use/forestbeam.jpg"
				;;
esac


# how to add new themes
# 1) define colors in polybar config.ini file
# 2) add theme name in colors & themes section of this file with three sharps and a space
# 3) define colors in colors & themes section of this file
# 4) bind colors and wallpaper in definitions section of this file
# 5) create rofi theme .rasi file with the same name as theme here

# this script changes:
# in bspwm's bspwmrc: border color and wallpaper
# in rofi's config.rasi: theme name
# in polybar's config.ini: current color definitions
#
# in the lockscreen script: the color flags
