# Defined via `source`
function ll \
    --wraps='exa -l --color=always --group-directories-first --icons' \
    --description 'list long format'
  exa -l --color=always --group-directories-first --icons $argv
        
end
