function readvars \
    --argument-name filename \
    --description "Source shell environment variable file with fish"

    while read LINE
        string match --quiet --regex --groups-only -- '^\s*(?<VAR>\w+)\s*=\s*(?<VALUE>.*)$' $LINE
        if test \( -n "$VAR" \) -a \( -n "$VALUE" \)
            set -gx "$VAR" $VALUE
            printf 'Exporting %s = %s\n' $VAR $VALUE
        end
    end < $filename
end
