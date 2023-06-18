# Defined via `source`
function la --wraps='exa -a --color=always --group-directories-first --icons' --description 'alias la=exa -a --color=always --group-directories-first --icons'
  exa -a --color=always --group-directories-first --icons $argv
        
end
