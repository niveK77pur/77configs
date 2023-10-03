#!/bin/bash

MPV_CONFIG=~/.config/mpv

# uosc (AUR)
mkdir -p "$MPV_CONFIG/scripts" "$MPV_CONFIG/fonts"
ln -s /usr/share/mpv/scripts/uosc* "$MPV_CONFIG/scripts/"
ln -s /usr/share/mpv/fonts/uosc* "$MPV_CONFIG/fonts/"

# thumbfast (AUR)
# already in correct location

# anime4K (AUR)
ln -s /usr/share/anime4k "$MPV_CONFIG/shaders"

# sub-cut
# permalink: https://github.com/kelciour/mpv-scripts/blob/9a5cda4fc8f0896cec27dca60a32251009c0e9c5/sub-cut.lua
mkdir -p "$MPV_CONFIG/scripts"
curl 'https://raw.githubusercontent.com/kelciour/mpv-scripts/master/sub-cut.lua' > "$MPV_CONFIG/plugins/sub-cut.lua"
ln -s "$MPV_CONFIG/plugins/sub-cut.lua" "$MPV_CONFIG/scripts/"
