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

theme_name="$(choose)"
theme_file="$(grep -l "theme_name: $theme_name$" "$dir/"*"yaml")"

function extract {
    cat "$theme_file" | yq -r "$1"
}

echolor green ":: Generating theme file..."

cat <<-EOF > "$thf"
#!/bin/bash
export lin_theme="$(extract '.theme_name')"
export lin_color1="$(extract '.colors.color1.hex')"
export lin_color2="$(extract '.colors.color2.hex')"
export lin_color3="$(extract '.colors.color3.hex')"
export lin_color4="$(extract '.colors.color4.hex')"
export lin_wallpaper="$(eval echo $(extract '.wallpaper.path'))"
EOF

echolor green ":: File generated!"

rofi_file="$(eval echo $(extract '.files.rofi'))"
polybar_file="$(eval echo $(extract '.files.polybar'))"
if [[ ! -e "$rofi_file" ]] || [[ ! -e "$polybar_file" ]]
then
    echolor red ":: Unable to symlink. Exiting."
    sane "$rofi_file"
    sane "$polybar_file"
    exit 1
fi

ln -sf "$rofi_file" "$HOME/.config/rofi/current-theme.rasi"
ln -sf "$polybar_file" "$HOME/.config/polybar/current-theme.ini"

bspc wm -r




# lockscreen

# dunst
