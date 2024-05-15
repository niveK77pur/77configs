#!/usr/bin/env bash

file=$1

filetype="$(file -Lb --mime-type "$file")"
script_path_prefix=~/.config/77configs/config/lf/preview
valid_lf_version=$(
    [[ $(lf --version | sed 's/r//g') -gt 30 ]]
    echo $?
)

if [[ $filetype =~ ^image ]]; then
    if type chafa >/dev/null && [ "$valid_lf_version" -eq 0 ]; then
        "$script_path_prefix/lf_sixel_preview" "$@"
    else
        file --brief "$file"
    fi
elif [[ $filetype =~ ^video ]]; then
    if type chafa >/dev/null && [ "$valid_lf_version" -eq 0 ]; then
        w="$2"
        h="$3"
        ffmpegthumbnailer -s0 -m -f -i "$file" -c jpeg -o- | chafa -f sixel -s "${w}x${h}" --animate off --polite on
    else
        file --brief "$file"
    fi
else
    if type pistol >/dev/null; then
        pistol "$file"
    else
        "$script_path_prefix/lf_preview_custom.sh" "$@"
    fi
fi
