# Defined via `source`
function ls \
    --wraps='exa -l --color=always --group-directories-first --icons' \
    --description 'alias ls=exa -l --color=always --group-directories-first --icons'
  exa -l --color=always --group-directories-first --icons $argv
        
end
