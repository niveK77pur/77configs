#!/bin/bash

# WALLPAPER_DIR=~/Pictures/i3wallpapers/active
WALLPAPER_DIR=~/Pictures/i3wallpapers/anime_games

ps -u $USER | grep redshift >/dev/null || {
    echo "Starting redshift ..."
    redshift -l 49:6 -t 6000:2000 &
}

ps -u $USER | grep picom >/dev/null || {
    echo "Starting picom ..."
    # picom --backend glx &
    picom &
}

# ps -u $USER | grep dunst >/dev/null || {
#     echo "Starting dunst ..."
#     dunst &
# }

echo "Selecting wallpaper from '$WALLPAPER_DIR'"
feh --bg-fill --randomize "$WALLPAPER_DIR"
# feh --no-fehbg --bg-fill --randomize "$WALLPAPER_DIR"
# wal -qi "$WALLPAPER_DIR" --saturate 0.5
# wal -qi "$WALLPAPER_DIR" --backend haishoku --saturate 0.5

echo "init screen done."
