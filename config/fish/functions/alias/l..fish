# Defined via `source`
function l. \
    --wraps='exa -ald --color=always --group-directories-first --icons .*' \
    --description 'list only dotfiles'
  exa -ald --color=always --group-directories-first --icons .* $argv
        
end
