# Defined via `source`
function ls \
    --wraps='eza --color=always --group-directories-first --icons' \
    --description 'alias ls=eza --color=always --group-directories-first --icons'
  eza --color=always --group-directories-first --icons $argv
        
end
