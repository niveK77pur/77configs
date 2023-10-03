#!/bin/bash

MPV_CONFIG=~/.config/mpv

TMP_UOSC=$(mktemp)
TMP_ANIME4K=$(mktemp)
trap "rm $TMP_UOSC $TMP_ANIME4K" EXIT

# uosc
wget --output-document="$TMP_UOSC" https://github.com/tomasklaen/uosc/releases/latest/download/uosc.zip
unzip -d "$MPV_CONFIG" "$TMP_UOSC"

# thumbfast
mkdir -p "$MPV_CONFIG/plugins"
(cd "$MPV_CONFIG/plugins" && git clone https://github.com/po5/thumbfast)
ln -s "$MPV_CONFIG/plugins/thumbfast/thumbfast.lua" "$MPV_CONFIG/scripts/"

# anime4K
mkdir -p "$MPV_CONFIG/shaders"
wget --output-document="$TMP_ANIME4K" https://github.com/bloc97/Anime4K/releases/download/v4.0.1/Anime4K_v4.0.zip
unzip -od "$MPV_CONFIG/shaders" "$TMP_ANIME4K"

# sub-cut
# permalink: https://github.com/kelciour/mpv-scripts/blob/9a5cda4fc8f0896cec27dca60a32251009c0e9c5/sub-cut.lua
mkdir -p "$MPV_CONFIG/scripts"
wget --output-document="$MPV_CONFIG/plugins/sub-cut.lua" 'https://raw.githubusercontent.com/kelciour/mpv-scripts/master/sub-cut.lua'
ln -s "$MPV_CONFIG/plugins/sub-cut.lua" "$MPV_CONFIG/scripts/"
