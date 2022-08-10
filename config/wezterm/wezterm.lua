local wezterm = require('wezterm')
return {

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                                    Fonts
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--{{{

    font = wezterm.font {
        family = 'Fira Code Nerd Font',
        harfbuzz_features = { 'zero' }, -- 0 with dot instead of line through
    },

--}}}
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                                 Keybindings
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--{{{

    -- key_map_preference = ({"Mapped", "Physical"})[1],

    keys = {

        -- Disable default keys {{{

        -- increase font size
        { mods = 'CTRL', key = '=', action = 'DisableDefaultAssignment' },

        --}}}

        { mods = 'CTRL', key = '.', action = wezterm.action.IncreaseFontSize },
        { mods = 'CTRL', key = '-', action = wezterm.action.DecreaseFontSize },

    },

--}}}
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                                  Interface
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--{{{

    -- set to false to disable the tab bar completely
    enable_tab_bar = true,

    -- hide the tab bar when there is only a single tab in the window
    hide_tab_bar_if_only_one_tab = true,

    -- Everforest: https://github.com/sainnhe/everforest
    colors = {
        foreground = '#d3c6aa',
        -- 1: hard, 2: medium, 3: soft
        background = ({'#2b3339', '#2f383e', '#323d43'})[2],
    },

--}}}
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                                  Behaviour
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--{{{

    warn_about_missing_glyphs = false,

    check_for_updates = false,

--}}}

}
-- vim: foldmethod=marker
