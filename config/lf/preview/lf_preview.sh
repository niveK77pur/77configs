#!/usr/bin/env bash
FILE="$1"
W="$2"
H="$3"
X="$4"
Y="$5"

case "$1" in
    *.tar*) tar tf "$1";;
    *.zip) unzip -l "$1";;
    *.rar) unrar l "$1";;
    *.7z) 7z l "$1";;
    *.pdf) pdftotext "$1" -;;
    # *.png|*.jpg|*.JPG) kitty +icat --silent --transfer-mode file --place "${W}x${H}@${X}x${Y}" "$FILE";;
    # *.png|*.jpg|*.JPG) wezterm imgcat --width "$W" --height "$H" "$FILE";;
    *) bat --color=always --style=plain --line-range "0:$H" "$1";;
esac

