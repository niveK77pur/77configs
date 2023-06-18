# Defined via `source`
function lt --wraps='exa -aT --color=always --group-directories-first --icons' --description 'alias lt=exa -aT --color=always --group-directories-first --icons'
  exa -aT --color=always --group-directories-first --icons $argv
        
end
