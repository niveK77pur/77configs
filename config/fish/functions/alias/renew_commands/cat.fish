# Defined via `source`
function cat \
    --wraps='bat --style header --style snip --style changes --style header' \
    --description 'cat aliased to bat'
  bat --style header --style snip --style changes --style header $argv
        
end
