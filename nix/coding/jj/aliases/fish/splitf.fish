set --function options

set options $options (fish_opt --short r --long revisions --optional-val)
set options $options (fish_opt --short m --long message --optional-val)

# @fish-lsp-disable-next-line 4004
argparse --ignore-unknown $options -- $argv
or return

set --function rev $_flag_revisions
set --query --function _flag_revisions; or set rev @

set --function paths (jj diff -r $rev --template 'concat(self.path().display(), "\n")')
set --local paths_count (count $paths)
for i in (seq $paths_count)
    set --local path $paths[$i]
    set --local message (string replace {} $path $_flag_message)
    if [ $rev = "@" ]
        jj commit -m $message $path
    else
        if [ $i -ne $paths_count ]
            jj split -r "$rev" -m $message $path
            set rev "$rev+"
        else
            # We are on the last path
            jj desc -m $message $rev
        end
    end
end
