# see also: https://github.com/jorgebucaran/cookbook.fish

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                                   Set values
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Shell variables --------------------------------------------------------------
set -gx EDITOR nvim
set -gx MANPAGER "less --use-color"
set -gx TERMINAL wezterm

set -gx LYEDITOR "nvr +:'call cursor(%(line)s,%(char)s)' %(file)s"

# Hide welcome message ---------------------------------------------------------
set fish_greeting
# set VIRTUAL_ENV_DISABLE_PROMPT "1"

# Fake recursive function path -------------------------------------------------
# https://github.com/fish-shell/fish-shell/issues/1819#issuecomment-63728658
set -p fish_function_path (find ~/.config/77configs/config/fish/functions -mindepth 1 -type d)
# set -p __fish_config_dir (find ~/.config/77configs/config/fish/conf.d -mindepth 1 -type d)

# Export variable need for qt-theme --------------------------------------------
if type "qtile" >> /dev/null 2>&1
    set -x QT_QPA_PLATFORMTHEME "qt5ct"
end

# Set settings for https://github.com/franciscolourenco/done -------------------
set -U __done_min_cmd_duration 10000
set -U __done_notification_urgency_level low

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                               Environment setup
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Apply .profile: use this to put fish compatible .profile stuff in
if test -f ~/.fish_profile
    source ~/.fish_profile
end

# Extend PATH ------------------------------------------------------------------

# Add ~/.local/bin to PATH
if test -d ~/.local/bin
    fish_add_path ~/.local/bin
end

# Add ~/bin to PATH
if test -d ~/bin
    fish_add_path ~/bin
end

# Add depot_tools to PATH
if test -d ~/Applications/depot_tools
    fish_add_path ~/Applications/depot_tools
end

# Binaries in GOPATH
if test -d ~/go/bin
    fish_add_path ~/go/bin
end

# CARGO binaries
if test -d ~/.cargo/bin
    fish_add_path ~/.cargo/bin
end

# Ruby gem binaries
if test -d ~/.local/share/gem/ruby/3.0.0/bin
    fish_add_path ~/.local/share/gem/ruby/3.0.0/bin
end

# TeX Live ---------------------------------------------------------------------
# if installed using the install script `install-tl`
# (https://tug.org/texlive/quickinstall.html)
set -l texlive_path /usr/local/texlive/2023
if [ -d $texlive_path ]
    set -ax MANPATH $texlive_path/texmf-dist/doc/man
    set -ax INFOPATH $texlive_path/texmf-dist/doc/info
    fish_add_path $texlive_path/bin/x86_64-linux
end

# fzf.fish ---------------------------------------------------------------------
if status is-interactive
    if type -q fzf_configure_bindings && type -q atuin
        # prefer atuin's history
        fzf_configure_bindings --history=
    end
    if type -q atuin
        atuin init --disable-up-arrow fish | source
    end
    # fzf.fish will setup bindings automatically if plugin is installed
end

# NeoVim -----------------------------------------------------------------------
# https://github.com/martineausimon/nvim-lilypond-suite/issues/19
alias nvim "SHELL=/bin/bash $(which nvim)"
