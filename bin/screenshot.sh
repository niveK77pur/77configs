#!/bin/bash

VIEWER=feh
VIEWER_FLAGS="--class floaty"

EDITOR=gimp
EDITOR_FLAGS="--new-instance --no-splash --no-data"

helpMessage() {
    echo -e "Usage:
    $(basename "$0")
    $(basename "$0") [awfvh]
    $(basename "$0") d <delay_time>
    $(basename "$0") r [<geometry>]
Where:
    a|area\tselect area (same as with no arguments)
    w|window\tselect window
    f|full\tfull screen
    d|delay\tselect area after delay (2nd argument)
    v|view\tview screenshot
    e|edit\tedit screenshot
    r|resize\tresized screenshot (geometry as specified for imagemagick)
    h|help\tprint this help message"
    exit 0
}

[ -z $SCREENSHOT_FILE ] && SCREENSHOT_FILE="$HOME/Pictures/VinLudensScreenshot.png"

if [ -z "$1" ]; then
    import $SCREENSHOT_FILE
else
    case "$1" in
        a|area)     import $SCREENSHOT_FILE ;;
        w|window)   import -screen $SCREENSHOT_FILE ;;
        f|full)     import -window root $SCREENSHOT_FILE;;
        d|delay)    sleep ${2:-1} && import $SCREENSHOT_FILE ;;
        v|view)
            # make copy to avoid image changing when new screenshot is taken
            IMG="$(mktemp)"
            cp "$SCREENSHOT_FILE" "$IMG"
            $VIEWER $VIEWER_FLAGS "$IMG"
            rm "$IMG"
            exit 0
            ;;
        e|edit)
            $EDITOR $EDITOR_FLAGS "$SCREENSHOT_FILE"
            ;;
        r|resize)
            import $SCREENSHOT_FILE
            magick "$SCREENSHOT_FILE" -resize "${2:-400x}" "$SCREENSHOT_FILE"
            ;;
        h|help)     helpMessage ;;
        *)          echo "Wrong argumet: '$1'" ; helpMessage ;;
    esac
fi

xclip -selection clipboard -t image/png -i "$SCREENSHOT_FILE" && notify-send "$(basename $0)" "Copied to clipboard."
