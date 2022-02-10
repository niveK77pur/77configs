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
    for f in $(find "$SRC" -type f -printf '%P\n')
    do
        DIR="$(dirname "$DEST/$f")"
        [ -d "$DIR" ] || mkdir -p "$DIR"
        if [ -f "$DEST/$f" ]
        then
            echo "$DEST/$f already exists. Skipping."
            #rsync -PUt "$SRC/$f" "$DEST/$f"
            #rm -v "$DEST/$f"
        else
            ln -s "$(realpath "$SRC/$f")" "$DEST/$f"
        fi
    done
}

# $HOME/bin/ {{{1
install-files "bin" "$HOME/bin"

# $HOME/.config/ {{{1
install-files "config" "$HOME/.config"

# $HOME/ {{{1
install-files "home" "$HOME"

#}}}1
