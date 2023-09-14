# Defined via `source`
function l. \
    --wraps='eza -ald --color=always --group-directories-first --icons .*' \
    --description 'list only dotfiles'
  eza -ald --color=always --group-directories-first --icons .* $argv
        
end
