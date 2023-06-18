# Defined via `source`
function la --wraps='exa -a --color=always --group-directories-first --icons' --description 'list all files and dirs'
  exa -a --color=always --group-directories-first --icons $argv
        
end
