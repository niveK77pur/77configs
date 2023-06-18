# Defined via `source`
function ls \
    --wraps='exa -al --color=always --group-directories-first --icons' \
    --description 'alias ls=exa -al --color=always --group-directories-first --icons'
  exa -al --color=always --group-directories-first --icons $argv
        
end
