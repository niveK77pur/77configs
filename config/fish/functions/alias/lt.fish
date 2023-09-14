# Defined via `source`
function lt \
    --wraps='eza -aT --color=always --group-directories-first --icons' \
    --description 'tree listing'
  eza -aT --color=always --group-directories-first --icons $argv
        
end
