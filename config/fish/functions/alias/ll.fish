# Defined via `source`
function ll --wraps='exa -l --color=always --group-directories-first --icons' --description 'alias ll=exa -l --color=always --group-directories-first --icons'
  exa -l --color=always --group-directories-first --icons $argv
        
end
