if status --is-interactive && type -q starship
    starship init fish --print-full-init | source
end
