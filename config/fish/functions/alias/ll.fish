# Defined via `source`
function ll \
    --wraps='eza -la --color=always --group-directories-first --icons' \
    --description 'list long format'
  eza -la --color=always --group-directories-first --icons $argv
        
end
