# Defined via `source`
function jctl --wraps='journalctl -p 3 -xb' --description 'Get the error messages from journalctl'
  journalctl -p 3 -xb $argv
        
end
