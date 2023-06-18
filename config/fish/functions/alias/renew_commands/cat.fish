# Defined via `source`
function cat --wraps='bat --style header --style snip --style changes --style header' --description 'alias cat=bat --style header --style snip --style changes --style header'
  bat --style header --style snip --style changes --style header $argv
        
end
