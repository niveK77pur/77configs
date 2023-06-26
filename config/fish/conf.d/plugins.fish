if not functions -q fundle
    # eval (curl -sfL https://git.io/fundle-install)
    exit
end

fundle plugin 'PatrickF1/fzf.fish'
fundle plugin 'franciscolourenco/done'

fundle init
