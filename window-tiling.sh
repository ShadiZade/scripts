#!/bin/bash

function tiled-mode {
    pkill polybar
    bspc node -t tiled
    $HOME/.config/polybar/scripts/polybar-launch.sh &
    bspc config top_padding 35
    bspc config border_width 5
    bspc config window_gap 8
}

# function psuedotiled-mode {
#     pkill polybar
#     $HOME/.config/polybar/scripts/polybar-launch.sh &
#     bspc node -t psuedo_tiled
#     bspc config top_padding 35
#     bspc config border_width 5
#     bspc config window_gap 8
# }

function floating-mode {
    pkill polybar
    $HOME/.config/polybar/scripts/polybar-launch.sh &
    bspc node -t floating
    bspc config top_padding 35
    bspc config border_width 5
    bspc config window_gap 8
}

function work-mode {
    bspc node -t tiled
    pkill polybar &
    bspc config border_width 3
    bspc config window_gap 0
    bspc config top_padding 0
}

function fullscreen-mode {
    pkill polybar
    $HOME/.config/polybar/scripts/polybar-launch.sh &
    bspc config top_padding 35
    bspc config border_width 5
    bspc config window_gap 8
    bspc node -t fullscreen || bspc node -t tiled
}

"$(grep "^function" ~/Repositories/scripts/window-tiling.sh | awk '{print $2}' | rofi -dmenu)"
