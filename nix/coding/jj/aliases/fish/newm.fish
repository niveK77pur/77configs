set --function options
set options $options (fish_opt --short A --long insert-after --optional-val)
set options $options (fish_opt --short B --long insert-before --optional-val)
# @fish-lsp-disable-next-line 4004
argparse --exclusive insert-after,insert-before --ignore-unknown $options -- $argv; or return

# TODO: Add check to ensure only one of the options is given?
set --function revset
set --function revset_flag
test (count $argv) -eq 1; and begin
    set revset $argv
end
set --query --function _flag_insert_after; and begin
    set revset $_flag_insert_after
    set revset_flag --insert-after
end
set --query --function _flag_insert_before; and begin
    set revset $_flag_insert_before
    set revset_flag --insert-before
end
test -n "$revset"; or begin
    echo No valid revset has been given.
    echo If given as argument, make sure to provide only 1 revset
    exit 1
end

# move the named bookmark
jj new $argv $revset_flag $revset
and jj bookmark move $revset -t $revset+
