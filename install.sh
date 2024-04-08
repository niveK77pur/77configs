#!/bin/bash
# vim: foldmethod=marker

# Some info about this script {{{
# This script 'installs' all the files to their corresponding locations
#
# What does it do:
#   - Directories will be created if nonexistent
#   - Files will be SYMLINKED if nonexistent
#
# This way you can add files in a folder that should not be tracked
# (i.e. symlinked) in this repository. Let's say there are files in
# ~/bin that you don't want to be in this repository. You can simply
# add them to ~/bin directly instead of putting them here and have
# them symlinked. If the whole directory was symlinked instead of its
# files, then adding files to ~/bin will make them be tracked here.
#}}}

install-files() {
    SRC="$1"
    DEST="$2"
    find "$SRC" -type f -printf '%P\0' | while read -rd $'\0' f; do
        DIR="$(dirname "$DEST/$f")"
        [ -d "$DIR" ] || mkdir -p "$DIR"
        if [ -f "$DEST/$f" ]; then
            :
            #echo "$DEST/$f already exists. Skipping."
            #rsync -PUt "$SRC/$f" "$DEST/$f"
            #rm -v "$DEST/$f"
        else
            ln -vs "$(realpath "$SRC/$f")" "$DEST/$f"
        fi
    done
}

install-go() {
    PROG_NAME="$1"
    SRC="compiled-programs/$PROG_NAME"
    DEST="${2:-$HOME/go/bin}"
    [ -d "$DEST" ] || mkdir -p "$DEST"
    if [ ! -f "$DEST/$PROG_NAME" ]; then
        (cd "$SRC" && go build) &&
            ln -vs "$(realpath "$SRC/$PROG_NAME")" "$DEST/$PROG_NAME"
    fi
}

install-files "bin" "$HOME/bin"

install-files "config" "$HOME/.config"

install-files "home" "$HOME"

install-go "mount-go"

install-go "ffmpeg-cut-timestamps"
