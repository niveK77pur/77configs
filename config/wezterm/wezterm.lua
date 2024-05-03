local wezterm = require('wezterm')
local act = wezterm.action

-- Show which key table is active in the status area {{{
wezterm.on('update-right-status', function(window, pane)
  local name = window:active_key_table()
  if name then
    name = 'TABLE: ' .. name
  end
  window:set_right_status(name or '')
end)
-- }}}

return {

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                                    Fonts
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--{{{

    font_size = 11.1,

    font = wezterm.font {
        family = 'Fira Code Nerd Font',
        harfbuzz_features = { 'zero' }, -- 0 with dot instead of line through
        weight = 'Medium',
    },

    -- https://wezfurlong.org/wezterm/config/lua/config/font_rules.html
    font_rules = {
        {
            italic = true,
            font = wezterm.font('VictorMono NF', { italic=true, weight='Medium', })
            -- font = wezterm.font('Fira Code', { italic=true, weight='Medium', })
        }
    },

--}}}
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                                 Keybindings
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--{{{

    -- Default Shortcut / Key Binding Assignments
    --  https://wezfurlong.org/wezterm/config/default-keys.html
    -- Available Key Assignments:
    --  https://wezfurlong.org/wezterm/config/lua/keyassignment/index.html

    -- key_map_preference = ({"Mapped", "Physical"})[1],

    leader = { mods = 'CTRL|ALT', key = 'w', timeout_milliseconds = 1000 },

    keys = { -- {{{

        -- Disable default keys {{{

        -- increase font size
        { mods = 'CTRL', key = '=', action = 'DisableDefaultAssignment' },
        { mods = 'CTRL|SHIFT', key = 'K', action = 'DisableDefaultAssignment' },

        -- toggle full screen
        { mods = 'ALT', key = 'Enter', action = 'DisableDefaultAssignment' },

        --}}}

        { mods = 'CTRL', key = '.', action = act.IncreaseFontSize },
        { mods = 'CTRL', key = '-', action = act.DecreaseFontSize },


        -- ActivatePaneDirection - Vim Motion
        { mods = 'CTRL|SHIFT', key = 'h', action = act.ActivatePaneDirection 'Left' },
        { mods = 'CTRL|SHIFT', key = 'l', action = act.ActivatePaneDirection 'Right' },
        { mods = 'CTRL|SHIFT', key = 'k', action = act.ActivatePaneDirection 'Up' },
        { mods = 'CTRL|SHIFT', key = 'j', action = act.ActivatePaneDirection 'Down' },

        -- Pane Activation Table
        { mods = 'LEADER|CTRL', key = 'p', action = act.ActivateKeyTable {
            name = 'manage_panes',
            one_shot = true,
            replace_current = false,
        } },


        -- Activate Tab
        { mods = 'CTRL|ALT', key = '1', action = act.ActivateTab(0) },
        { mods = 'CTRL|ALT', key = '2', action = act.ActivateTab(1) },
        { mods = 'CTRL|ALT', key = '3', action = act.ActivateTab(2) },
        { mods = 'CTRL|ALT', key = '4', action = act.ActivateTab(3) },
        { mods = 'CTRL|ALT', key = '5', action = act.ActivateTab(4) },
        { mods = 'CTRL|ALT', key = '6', action = act.ActivateTab(5) },
        { mods = 'CTRL|ALT', key = '7', action = act.ActivateTab(6) },
        { mods = 'CTRL|ALT', key = '8', action = act.ActivateTab(7) },
        { mods = 'CTRL|ALT', key = '9', action = act.ActivateTab(-1) },


        -- Scrollback Activation Table
        { mods = 'LEADER|CTRL', key = 's', action = act.ActivateKeyTable {
            name = 'scrollback_table',
            one_shot = false,
            replace_current = false,
        } },

    }, -- }}}

    key_tables = { -- {{{
        -- https://wezfurlong.org/wezterm/config/key-tables.html

        -- {{{ panes

        manage_panes = {
            -- resize panes
            { mods = 'CTRL', key = 'p', action = act.ActivateKeyTable {
                name = 'panes_continuous',
                one_shot = false,
                replace_current = false,
            } },

            -- Split Panes
            { mods = 'CTRL', key = 'h', action = act.SplitVertical },
            { mods = 'CTRL', key = 'v', action = act.SplitHorizontal },
            -- Pane Selection
            { mods = 'CTRL', key = 's', action = act.PaneSelect{mode="Activate"} },
            -- Toggle Pane Zoom
            { mods = 'CTRL', key = 'z', action = act.TogglePaneZoomState },
            -- move panes
            { mods = 'CTRL', key = 'm', action = act.PaneSelect{mode="SwapWithActive"} },
        },

        panes_continuous = {
            -- resize
            { mods = 'CTRL', key = 'h', action = act.AdjustPaneSize { 'Left',  5 } },
            { mods = 'CTRL', key = 'j', action = act.AdjustPaneSize { 'Down',  5 } },
            { mods = 'CTRL', key = 'k', action = act.AdjustPaneSize { 'Up',    5 } },
            { mods = 'CTRL', key = 'l', action = act.AdjustPaneSize { 'Right', 5 } },
            -- rotate panes
            { mods = 'CTRL', key = 'b', action = act.RotatePanes 'CounterClockwise', },
            { mods = 'CTRL', key = 'n', action = act.RotatePanes 'Clockwise' },
            -- Cancel the mode by pressing escape
            { key = 'Escape', action = 'PopKeyTable' },
        },

        -- }}}

        scrollback_table = {
            { mods = 'CTRL', key = 'k', action = act.ScrollByPage(-0.5) },
            { mods = 'CTRL', key = 'j', action = act.ScrollByPage(0.5) },

            { mods = 'CTRL', key = 'c', action = act.ClearScrollback 'ScrollbackOnly' },
            { mods = 'CTRL|ALT', key = 'c', action = act.Multiple {
                act.ClearScrollback 'ScrollbackAndViewport',
                act.SendKey { key = 'L', mods = 'CTRL' },
            }, },

            { key = 'Escape', action = 'PopKeyTable' },
        },

    }, -- }}}

    -- https://wezfurlong.org/wezterm/config/mouse.html
    mouse_bindings = { -- {{{

        -- block select (default ALT+Left)
        {
            event = { Down = { streak = 1, button = 'Left' } },
            action = act.SelectTextAtMouseCursor 'Block',
            mods = 'CTRL|ALT',
        },
        {
            event = { Drag = { streak = 1, button = 'Left' } },
            action = act.ExtendSelectionToMouseCursor("Block"),
            mods = 'CTRL|ALT',
        },
        {
            event = { Up = { streak = 1, button = 'Left' } },
            action = act.CompleteSelection("PrimarySelection"),
            mods = 'CTRL|ALT',
        },

    },
    -- }}}

--}}}
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                                  Interface
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--{{{

    -- set to false to disable the tab bar completely
    enable_tab_bar = true,

    -- hide the tab bar when there is only a single tab in the window
    hide_tab_bar_if_only_one_tab = true,


    color_scheme = 'Pinkmare',

    color_schemes = {

        ['Everforest'] = { -- {{{
            -- https://github.com/Yagua/nebulous.nvim
            foreground = '#d3c6aa',
            -- 1: hard, 2: medium, 3: soft
            background = ({'#2b3339', '#2f383e', '#323d43'})[2],
        }, -- }}}

        ['Nebulous Midnight'] = { -- {{{
            -- https://github.com/Yagua/nebulous.nvim
            foreground = '#ced5e5', -- Midnight.White
            background = '#201f30', -- Midnight.background
            cursor_bg = '#e796ff', -- Midnight.Orange
            cursor_border = '#e796ff', -- Midnight.Orange
            cursor_fg = 'black',
            selection_bg = '#404554', -- Midnight.Grey
            compose_cursor = 'white',
            ansi = {
                'black',   -- 0 = black
                '#fd2e6a', -- 1 = red     (Midnight.DarkRed)
                '#61d143', -- 2 = green   (Midnight.DarkGreen)
                '#edbe34', -- 3 = yellow  (Nova.DarkYellow)
                '#007ed3', -- 4 = blue    (Twilight.DarkBlue)
                '#fe92e1', -- 5 = magenta (Night.DarkMangenta)
                '#ffae2d', -- 6 = cyan    (Midnight.DarkCyan)
                '#404544', -- 7 = white   (Midnight.Grey)
            },
            brights = {
                'black',   -- 0 = black
                '#f94b7d', -- 1 = red     (Midnight.Red)
                '#b8ee92', -- 2 = green   (Midnight.Green)
                '#ddcf43', -- 3 = yellow  (Nova.Yellow)
                -- '#00d5a7', -- 4 = blue (Midnight.Blue)
                '#47b5d8', -- 4 = blue    (Twilight.Blue)
                '#f95ce6', -- 5 = magenta (Night.Mangenta)
                '#5cdfdf', -- 6 = cyan    (Midnight.Cyan)
                '#ced5e5', -- 7 = white   (Midnight.White)
            },
        }, -- }}}

        ['Pinkmare'] = { -- {{{
            -- https://github.com/Matsuuu/pinkmare
            foreground = '#fae8b6', -- fg
            background = '#202330', -- bg0
            -- cursor_bg = '#f2448b',
            cursor_border = '#e796ff',
            cursor_fg = 'black',
            selection_bg = '#472541',
            compose_cursor = 'white',
            ansi = {
                '#4e5676',   -- 0 = black
                '#ff38a2', -- 1 = red     ()
                '#b8ee92', -- 2 = green   (Midnight.Green)
                '#ddcf43', -- 3 = yellow  (Nova.Yellow)
                '#47b5d8', -- 4 = blue    (Twilight.Blue)
                '#f95ce6', -- 5 = magenta (Night.Mangenta)
                '#5cdfdf', -- 6 = cyan    (Midnight.Cyan)
                '#ced5e5', -- 7 = white   (Midnight.White)
            },
            brights = {
                '#4e5676',   -- 0 = black
                '#f94b7d', -- 1 = red     (Midnight.Red)
                '#9cd162', -- 2 = green   ()
                '#ffc85b', -- 3 = yellow  ()
                '#007ed3', -- 4 = blue    (--)
                '#d9bcef', -- 5 = magenta (purple)
                '#87c095', -- 6 = cyan    ()
                '#fff0f5', -- 7 = white   (gold)
            },
        }, -- }}}

    },


    window_background_opacity = 1.0,

    window_padding = {
        left   = 10,
        right  = 10,
        top    = 10,
        bottom = 10,
    },

--}}}
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                                  Behaviour
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--{{{

    warn_about_missing_glyphs = false,

    check_for_updates = false,

    -- How many lines of scrollback you want to retain per tab
    -- scrollback_lines = 3500,

    -- uses rust regex: https://docs.rs/regex/1.3.9/regex/#syntax
    quick_select_patterns = {
        '\\b[[:alnum:][:punct:]]+\\b', -- "words"
    },
    quick_select_alphabet = ({ -- suggested alphabet for keyboard layout
        qwerty =  "asdfqwerzxcvjklmiuopghtybn",
        qwertz =  "asdfqweryxcvjkluiopmghtzbn",
        azerty =  "qsdfazerwxcvjklmuiopghtybn",
        dvorak =  "aoeuqjkxpyhtnsgcrlmwvzfidb",
        colemak = "arstqwfpzxcvneioluymdhgjbk",
    })['qwertz'],

    audible_bell = "Disabled",

    -- https://wezfurlong.org/wezterm/hyperlinks.html
    -- hyperlink_rules = {
    --     {
    --         -- github username/project
    --         regex = [[['"]([\w\d][-\w\d]+)/([-\w\d\.]+)['"]{1}]],
    --         format = 'https://www.github.com/$1/$2',
    --     },
    -- },

--}}}

}
-- vim: foldmethod=marker
