# Defined via `source`
function hw --wraps='hwinfo --short' --description 'alias hw=hwinfo --short'
  hwinfo --short $argv
        
end
