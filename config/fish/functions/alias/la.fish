# Defined via `source`
function la \
    --wraps='eza -a --color=always --group-directories-first --icons' \
    --description 'list all files and dirs'
  eza -a --color=always --group-directories-first --icons $argv
        
end
