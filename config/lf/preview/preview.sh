#!/bin/bash

file=$1

filetype="$(file -Lb --mime-type "$file")"
script_path_prefix=~/.config/77configs/config/lf/preview

if [[ "$filetype" =~ ^image|.*/pdf$ ]]; then
    if type chafa > /dev/null && [[ $(lf --version) -gt 30 ]]; then
        "$script_path_prefix/lf_sixel_preview" "$@"
    else
        file --brief "$file"
    fi
else
    if type pistol > /dev/null; then
        pistol "$file"
    else
        "$script_path_prefix/lf_preview_custom.sh" "$@"
    fi
fi
