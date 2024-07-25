#!/bin/bash
source ~/Repositories/scripts/essential-functions.sh
# generates current-theme in $usdd and symlinks program theme files

dir="$HOME/Repositories/dotfiles/themes"
thf="$usdd/current-theme"



function choose {
    for j in $(esa "$dir"/*yaml)
    do
	cat "$j" | yq -r '.theme_name'
    done | fzf --prompt 'choose theme: '
}



function generate {

    theme_name="$(choose)"
    theme_file="$(grep -l "theme_name: $theme_name$" "$dir/"*"yaml")"
    
    function extract {
	cat "$theme_file" | yq -r "$1"
    }
    
    echolor green ":: Generating current-theme file..."
    
cat <<-EOF > "$thf"
#!/bin/bash
export lin_theme="$(extract '.theme_name')"
export lin_color1="$(extract '.colors.color1.hex')"
export lin_color2="$(extract '.colors.color2.hex')"
export lin_color3="$(extract '.colors.color3.hex')"
export lin_color4="$(extract '.colors.color4.hex')"
export lin_wallpaper="$(eval echo $(extract '.wallpaper.path'))"
EOF

    echolor green ":: current-theme file generated!"
    
    rofi_file="$(eval echo $(extract '.files.rofi'))"
    polybar_file="$(eval echo $(extract '.files.polybar'))"
    dunst_file="$(eval echo $(extract '.files.dunst'))"
    if [[ ! -e "$rofi_file" ]] || [[ ! -e "$polybar_file" ]] || [[ ! -e "$dunst_file" ]]
    then
	echolor red ":: Unable to symlink. Exiting."
	exit 1
    fi
    
    ln -sf "$rofi_file" "$HOME/.config/rofi/current-theme.rasi"
    ln -sf "$polybar_file" "$HOME/.config/polybar/current-theme.ini"
    ln -sf "$dunst_file" "$HOME/.config/dunst/dunstrc"
    bspc wm -r
    killall dunst
}




function create {
    [[ -z "$1" ]] && {
	echolor red ":: Please input theme name."
	return
    }
    echo "$1" | grep -q " " && {
	echolor red ":: Please input theme name with dashes instead of spaces."
	return
    }
    [[ -e "$dir/$1.yaml" ]] && {
	echolor red ":: A theme by this name already exists."
	return
    }
    cp -n "$dir/.template.yaml" "$dir/$1.yaml"
    newtheme="$dir/$1.yaml"
    eval $EDITOR "$newtheme"
    echolor green ":: Generating theme files for other programs..."
    remake "$1"
}






function remake {
    theme_name="$1"
    theme_file="$dir/$1.yaml"
    [[ ! -e "$theme_file" ]] && {
	echolor red ":: No such a theme as ““$theme_name””."
	return 1
    }
    function extract {
	cat "$theme_file" | yq -r "$1"
    }
    color1="$(extract '.colors.color1.hex')"
    color2="$(extract '.colors.color2.hex')"
    color3="$(extract '.colors.color3.hex')"
    color4="$(extract '.colors.color4.hex')"
    color5="$(extract '.colors.color5.hex')"


    function remake-rofi {
cat <<EOF > "$HOME/Repositories/dotfiles/rofi/themes/$theme_name.rasi"
* {
    /* Theme colors */
    color1: #$color1;
    color2: #$color2;
    color5: #$color5;

$(cat "$HOME/Repositories/dotfiles/rofi/themes/.boilerplate")
EOF
    echolor green ":: ““rofi”” files remade for ““$theme_name””!"
    }
    function remake-polybar {
cat <<-EOF > "$HOME/Repositories/dotfiles/polybar/themes/$theme_name.ini"
[colors]
color1 = #$color1
color2 = #$color2
color3 = #$color3
color4 = #$color4
EOF
    echolor green ":: ““polybar”” files remade for ““$theme_name””!"
    }
    function remake-dunst {
dunstdir="$HOME/Repositories/dotfiles/dunst/themes"
cat <<EOF > "$dunstdir/$theme_name"
$(cat "$dunstdir/.boilerplate1")
	frame_color = "#$color2" #color2
$(cat "$dunstdir/.boilerplate2")
    background = "#$color1" #color1
    foreground = "#$color2" #color2
$(cat "$dunstdir/.boilerplate3")
EOF
    echolor green ":: ““dunst”” files remade for ““$theme_name””!"
    }
    remake-rofi
    remake-polybar
    remake-dunst
}


function remake-all {
    for j in $(esa "$dir" | grep "yaml")
    do
	echolor yellow ":: Remaking ““$j””"
	remake "$(echo "$j" | awk -F '.yaml' '{print $1}')"
    done
}


while getopts 'c:ar' OPTION; do
    case "$OPTION" in
	'c') create "$OPTARG" ;;
	'a') remake-all ;;
	'r') remake "$OPTARG" ;;
	*) echolor red ":: Incorrect option"
	   exit ;;
    esac
done
(( $OPTIND == 1 )) && generate
