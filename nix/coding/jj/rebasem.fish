set --function options

# specify source revisions
set options $options (fish_opt --short s --long source --optional-val)
set options $options (fish_opt --short r --long revisions --optional-val)

# specify target revisions (named bookmark)
set options $options (fish_opt --short d --long destination --optional-val)
set options $options (fish_opt --short A --long insert-after --optional-val)
set options $options (fish_opt --short B --long insert-before --optional-val)

# @fish-lsp-disable-next-line 4004
argparse --exclusive insert-after,insert-before --ignore-unknown $options -- $argv
or return

set --function source_revset
set --function source_flag
set --function dest_revset
set --function dest_flag
set --function bookmark_revset

# Source Revisions
set --query --function _flag_source; and begin
    set source_revset $_flag_source
    set source_flag --source
    set bookmark_revset "heads($source_revset::)"
end
set --query --function _flag_revisions; and begin
    set source_revset $_flag_revisions
    set source_flag --revisions
    set bookmark_revset "heads($source_revset)"
end

test -n "$source_revset"; or begin
    echo No valid source revset has been given.
    echo "Use one of"
    echo "    --source/-s or"
    echo "    --revisions/-r"
    exit 1
end

# Target Revisions
set --query --function _flag_destination; and begin
    set dest_revset $_flag_destination
    set dest_flag --destination
end
set --query --function _flag_insert_after; and begin
    set dest_revset $_flag_insert_after
    set dest_flag --insert-after
end
set --query --function _flag_insert_before; and begin
    set dest_revset $_flag_insert_before
    set dest_flag --insert-before
end

test -n "$dest_revset"; or begin
    echo No valid source revset has been given.
    echo "Use one of"
    echo "    --destination/-d or"
    echo "    --insert-after/-A or"
    echo "    --insert-before/-B"
    exit 1
end

jj rebase $argv $source_flag $source_revset $dest_flag $dest_revset
and jj bookmark move $dest_revset -t $bookmark_revset
