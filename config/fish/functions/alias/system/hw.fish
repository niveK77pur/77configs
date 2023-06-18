# Defined via `source`
function hw --wraps='hwinfo --short' --description 'Hardware info'
  hwinfo --short $argv
        
end
