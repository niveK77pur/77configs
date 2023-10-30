---@diagnostic disable-next-line: lowercase-global
version = '0.21.3'

---@diagnostic disable-next-line: undefined-global
local xplr = xplr -- The globally exposed configuration to be overridden.

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                                    General
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local general = xplr.config.general

general.enable_recover_mode = true

-- Panels ----------------------------------------------------------------------

general.panel_ui.default.border_style = {
    -- fg = 'LightCyan',
    fg = 'LightMagenta',
    -- fg = 'Gray',
    add_modifiers = {
        'Dim',
    },
}

general.panel_ui.default.title.style = {
    add_modifiers = {
        'Italic',
    },
}

-- Focus -----------------------------------------------------------------------

general.focus_ui.prefix = '< '
general.focus_ui.suffix = ' >'
general.default_ui.prefix = '  '
general.default_ui.suffix = ''

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                                  Node Types
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- local node_types = xplr.config.node_types

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                                    Layouts
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- local layouts = xplr.config.layouts

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                                     Modes
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- local modes = xplr.config.modes

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                                    Return
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

return {
    on_load = {},
    on_directory_change = {},
    on_focus_change = {},
    on_mode_switch = {},
    on_layout_switch = {},
}
