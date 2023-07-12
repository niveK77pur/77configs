# Defined via `source`
function ls \
    --wraps='exa --color=always --group-directories-first --icons' \
    --description 'alias ls=exa --color=always --group-directories-first --icons'
  exa --color=always --group-directories-first --icons $argv
        
end
