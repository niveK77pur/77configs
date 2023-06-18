# Defined via `source`
function lt \
    --wraps='exa -aT --color=always --group-directories-first --icons' \
    --description 'tree listing'
  exa -aT --color=always --group-directories-first --icons $argv
        
end
