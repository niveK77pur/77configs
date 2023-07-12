# Defined via `source`
function ll \
    --wraps='exa -la --color=always --group-directories-first --icons' \
    --description 'list long format'
  exa -la --color=always --group-directories-first --icons $argv
        
end
