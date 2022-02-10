-- vim: foldmethod=marker
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                                  Libraries
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                               Error handling
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- startup errors {{{1
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup {{{1
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
--}}}1


--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                            Variable definitions
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "alacritty"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.  {{{
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
local alt = "Mod1"
--}}}

-- Layouts {{{
-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    -- awful.layout.suit.floating,
    awful.layout.suit.tile,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}

local master_factor = 0.05
local client_factor = 0.10
--}}}

-- list with name of tags to be used
local tags_list = { "1", "2", "3", "4", "5", "6", "7", "8", "9" }

-- format string for temp files
local TMPFILE = "/tmp/awesomewm." .. os.getenv("USER") .. ".%s"

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                                  Functions
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

local function currentClientInMaster() --{{{1
    -- the master window (1st window in the stack)
    local master = awful.client.getmaster()
    -- number of windows in the master pane
    local master_count = awful.screen.focused().selected_tag.master_count
    -- PID of currently focussed client
    local current_pid = client.focus.pid
    -- match PIDs in master pane against PID of current client
    for i = 0,(master_count-1) do
        local master_pid = awful.client.next(i,master).pid
        if not master_pid then
            naughty.notify{
                title = "AWESOME: Check master windows",
                text = "Client with id " .. i .. " has no PID.",
                preset = naughty.config.presets.normal,
            }
        end
        if master_pid == current_pid then
            return true
        end
    end
    return false
end

local function checkValueInDomain(val, dom) --{{{1
    --[[ Return upper domain bound of 'val'. {{{
            'val' : A positive integer to be located in the domain.
            'dom' : List of tables. Each table MUST CONTAIN an integer 'val'
                attribute. The tables should be sorted in ascending order of
                their 'val' values.
            Function returns the table that marked the upper bound of the
            domain. If no upper bound exists, 'nil' will be returned.

            EXAMPLE:
            Given the following domain table
                local dom = {
                    {val = 5,  randomAttribute1 = "Hello", randomAttribute2 = "Bye"},
                    {val = 12, randomAttribute1 = "12345", randomAttribute2 = "098"},
                    {val = 18, randomAttribute1 = "ahem!", randomAttribute2 = "yes"},
                }
            We can now check in which domain a value lies.
                checkValueInDomain(-12,dom)   returns table with 'val = 5'
                checkValueInDomain(5,dom)     returns table with 'val = 5'
                checkValueInDomain(9,dom)     returns table with 'val = 12'
                checkValueInDomain(20,dom)    returns nil
    --}}}]]
    if val <= dom[1].val then
        return dom[1]
    end
    for i = 2,#dom do
        if dom[i-1].val < val and val <= dom[i].val then
            return dom[i]
        end
    end
    return nil
end

-- read, write & kill pid from file {{{1
local pid = {}
function pid.read(pidfile)
    local f = io.open(pidfile, 'r')
    if f then
        local PID = f:read("*all")
        f:close()
        return PID
    end
end
function pid.kill(pidfile)
    local PID = pid.read(pidfile)
    if PID then
        awful.spawn('kill ' .. PID)
        return true
    end
    return false
end
function pid.write(pidfile, PID)
    local f = io.open(pidfile, 'w')
    if f then
        f:write(PID)
        f:close()
    end
end

--}}}1

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                               Theme settings
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- naughty daemon {{{1
if naughty then
    beautiful.notification_font = "FiraCode 8"
    beautiful.notification_bg = "#444444"
    beautiful.notification_fg = "#ffffff"
    beautiful.notification_border_color = "#e68a00"
    beautiful.notification_shape = gears.shape.rounded_rect
    -- beautiful.notification_width = 10
    beautiful.notification_icon_size = 100
end
--}}}1

beautiful.useless_gap = 5
beautiful.border_focus = "#e68a00"
-- beautiful.border_normal = "#000000"

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                              Naughty settings
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

if naughty then
    naughty.config.padding = 25
    -- defaults {{{1
    naughty.config.defaults.timeout = 10
    naughty.config.defaults.margin = 8
    naughty.config.defaults.width = 500
    naughty.config.defaults.border_width = 2
    naughty.config.defaults.border_width = 2
    -- presets {{{1
    naughty.config.presets = {
        low = { bg = "#222222", fg = "#888888" },
        normal = { bg = "#444444", fg = "#ffffff" },
        critical = { bg = "#900000", fg = "#ffffff", timeout = 0 },
    }
    --}}}1
end

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                                    Menu
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- Create a main menu {{{1
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

-- myscreenshotmenu = {
--     { "screenshot", function() awful.spawn("screenshot.sh") end },
--     { "window", function() awful.spawn("screenshot.sh window") end },
--     { "full", function() awful.spawn("screenshot.sh full") end },
--     { "view", function() awful.spawn("screenshot.sh view") end },
--     { "edit", function() awful.spawn("screenshot.sh edit") end },
--     { "resize", function() awful.spawn("screenshot.sh resize") end },
-- }

mymainmenu = awful.menu({ items = {
    { "awesome", myawesomemenu, beautiful.awesome_icon },
    -- { "screenshot", myscreenshotmenu, "/usr/share/icons/Adwaita/48x48/devices/camera-photo-symbolic.symbolic.png" },
    { "open terminal", terminal },
} })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                                    Wibar
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- Widgets {{{1
-- Create a launcher widget {{{2
mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Keyboard map indicator and switcher {{{2
mykeyboardlayout = awful.widget.keyboardlayout()
mykeyboardlayout:buttons(gears.table.join(
    awful.button({}, 1, function() awful.spawn('sysinfo.sh') end)
))

-- Create a textclock widget {{{2
mytextclock = wibox.widget.textclock()

-- Brightness widget {{{2
local mybrightness = wibox.widget.textbox()

-- properties
mybrightness.file = "/sys/class/backlight/intel_backlight/brightness"
mybrightness.monitor = "inotifywait --monitor --event modify " .. mybrightness.file
mybrightness.retrieve = "xbacklight -get"
mybrightness.stepsize = 5
mybrightness.minimum = 10
mybrightness.str = ": %d%%"
mybrightness.pid = nil
mybrightness.pidfile = TMPFILE:format("mybrightness_pid")

--functions
function mybrightness:update()
    awful.spawn.easy_async(self.retrieve, function(stdout)
        local value = math.floor(stdout + 0.5)
        -- avoid lowering brightness to 0
        if value < self.minimum then self:set(self.minimum) end
        self.markup = self.str:format(value)
    end)
end
function mybrightness:set(value)
    awful.spawn('xbacklight -set ' .. value)
end
function mybrightness:inc(value)
    awful.spawn('xbacklight -steps 1 -inc ' .. value)
end

-- buttons and signals
mybrightness:buttons(awful.util.table.join(
    awful.button({}, 4, function() mybrightness:inc(mybrightness.stepsize) end),
    awful.button({}, 5, function() mybrightness:inc(- mybrightness.stepsize) end),
    awful.button({'Control'}, 4, function() mybrightness:inc(1) end),
    awful.button({'Control'}, 5, function() mybrightness:inc(-1) end)
))

-- check if 'pidfile' already exists and kill running process
pid.kill(mybrightness.pidfile)
-- wait for changes in brightness using 'inotifywait' to update widget
mybrightness:update()
mybrightness.pid = awful.spawn.with_line_callback(mybrightness.monitor, {
    stdout = function() mybrightness:update() end,
})
-- write pid to file
pid.write(mybrightness.pidfile, mybrightness.pid)

-- Battery widget {{{2
local mybattery = wibox.widget.textbox()

-- properties
mybattery.str = "%s %d%% (%s)"
mybattery.status_str = "%s%s%s:"
mybattery.percentage_str = "%s%d%%%s"
mybattery.time_str = "%s(%s)%s"
mybattery.strc = "%s%s%s %s%d%%%s (%s)"
mybattery.icon = ''
mybattery.domains = { --{{{
    {
        val = 10,
        text = "Battery level critical!",
        preset = naughty.config.presets.critical,
        notified = false,
        colorspan = { '<span foreground="red">', '</span>' },
    },
    {
        val = 30,
        text = "Battery is running low.",
        preset = naughty.config.presets.normal,
        notified = false,
        colorspan = { '<span foreground="orange">', '</span>' },
    },
    {
        val = 50,
        text = "Battery below 50%",
        preset = naughty.config.presets.low,
        notified = false,
        colorspan = { '<span foreground="yellow">', '</span>' },
    },
} --}}}
mybattery.status = { --{{{
    charging =      {
        colorspan = { "<span foreground='#7777ff'>", "</span>" },
    },
    discharging =   {
        colorspan = { "<span foreground='#cc5555'>", "</span>" },
    },
    notcharging =   {
        colorspan = { "<span foreground='#44bb44'>", "</span>" },
    },
} --}}}

-- function
function mybattery:update(stdout) --{{{
    -- extract information
    local status, percentage = stdout:match("^[^:]+: ([%w%s]+), (%d+)%%")
    local time = stdout:match("([%d:]+) [%w%s]+$")
    -- colors for battery status
    local status_t = self.status[status:lower():gsub("%s","")]
    if not status_t then status_t = { colorspan = { "", "" }, icon = self.icon } end
    local markup = self.status_str:format(status_t.colorspan[1], self.icon, status_t.colorspan[2])
    -- notify if battery is running low
    local p = tonumber(percentage)
    local t = checkValueInDomain(p, self.domains)
    if t then
        -- do not notify if switching domain while currently charging
        if status == "Charging" then goto endNotif end
        -- user already notified
        if t.notified then goto endNotif end
        -- reset 'notified' states of all domains
        for _, tab in pairs(self.domains) do
            tab.notified = false
        end
        -- send notification
        t.notified = true
        naughty.notify {
            title = "Battery Status",
            text = t.text,
            preset = t.preset,
        }
    end
    ::endNotif::
    do -- color for percentage
        local c1,c2
        if t and t.colorspan then
            c1,c2 = t.colorspan[1], t.colorspan[2]
        end
        markup = markup .. ' ' .. self.percentage_str:format(c1 or '', percentage, c2 or '')
    end
    -- add remaining time if available
    if time then
        local c1,c2
        if t and t.colorspan then
            c1,c2 = t.colorspan[1], t.colorspan[2]
        end
        markup = markup .. ' ' .. self.time_str:format(c1 or '',time,c2 or '')
    end
    -- update widget
    self.markup = markup or self.str:format(status, percentage, time)
end --}}}

-- watch battery status
awful.widget.watch("acpi --battery", 5, function(_, stdout)
    mybattery:update(stdout)
end)

-- Audio widget {{{2
local myaudio = wibox.widget.textbox()
--[[ TODO: use/make a better and more adapted monitor
        The current pactl solution seems to catch events that do not correspond
        to volume changes.
--]]

-- properties
myaudio.monitor = "pactl subscribe"
myaudio.retrieve = "amixer sget Master"
myaudio.stepsize = 5
myaudio.str = "墳: %s"
myaudio.prefix_str = "墳:"
myaudio.status_str = "%s%s%s"
myaudio.strc = "墳: %s%s%s"
myaudio.domains = { --{{{
    {
        val = 40,
    },
    {
        val = 70,
        colorspan = { '<span foreground="orange">', '</span>' }
    },
    {
        val = 100,
        colorspan = { '<span foreground="red">', '</span>' }
    },
} --}}}
myaudio.pid = nil
myaudio.pidfile = TMPFILE:format("myaudio_pid")

-- functions
function myaudio:update() --{{{
    awful.spawn.easy_async(self.retrieve, function(stdout)
        local volume, state = stdout:match("%[(%d+)%%%] %[(%l+)%]")
        local markup = self.prefix_str

        -- check special state of audio
        if state == "on" then
            -- colors for high volume
            local v = tonumber(volume)
            local t = checkValueInDomain(v, self.domains)
            if t and t.colorspan then
                markup = markup .. ' ' .. self.status_str:format(t.colorspan[1], volume .. '%', t.colorspan[2])
            else
                markup = markup .. ' ' .. self.status_str:format('',volume .. '%','')
            end
        elseif state == "off" then
            markup = markup .. ' ' .. self.status_str:format('','MUTE','')
        else
            markup = markup .. ' ' .. self.status_str:format('','??','')
        end

        -- update widget
        self.markup = markup or self.str:format(volume .. '%')
    end)
end --}}}
function myaudio:inc(value) --{{{
    local sign, val = tostring(value):match('(-?)(%d+)')
    if sign ~= '-' then sign = '+' end
    awful.spawn('amixer sset Master ' .. val .. '%' .. sign)
end --}}}
function myaudio:toggle() --{{{
    awful.spawn('amixer sset Master toggle')
end --}}}

-- buttons
myaudio:buttons(awful.util.table.join(
    awful.button({}, 1, myaudio.toggle),
    awful.button({}, 4, function() myaudio:inc(myaudio.stepsize) end),
    awful.button({}, 5, function() myaudio:inc(- myaudio.stepsize) end),
    awful.button({'Control'}, 4, function() myaudio:inc(1) end),
    awful.button({'Control'}, 5, function() myaudio:inc(-1) end)
))

-- kill existing instance
pid.kill(myaudio.pidfile)
-- wait for changes in audio using 'pactl subscribe'
-- TODO: better monitor
myaudio:update()
myaudio.pid = awful.spawn.with_line_callback(myaudio.monitor, {
    stdout = function(line)
        -- if not line:match("sink #0") then return end
        if not line:match("Event 'change' on sink #") then return end
        myaudio:update()
    end,
})
-- write pid to file
pid.write(myaudio.pidfile, myaudio.pid)

-- counter {{{2
--[[
local countdown = {
    widget   = wibox.widget.textbox(),
    checkbox = wibox.widget {
        checked      = false,
        check_color  = beautiful.fg_focus,  -- customize
        border_color = beautiful.fg_normal, -- customize
        border_width = 2,                   -- customize
        shape        = gears.shape.circle,
        widget       = wibox.widget.checkbox
    }
}
function countdown.set()
    awful.prompt.run {
        prompt       = "Countdown minutes: ", -- floats accepted
        textbox      = awful.screen.focused().mypromptbox.widget,
        exe_callback = function(timeout)
            countdown.seconds = tonumber(timeout)
            if not countdown.seconds then return end
            countdown.checkbox.checked = false
            countdown.minute_t = countdown.seconds > 1 and "minutes" or "minute"
            countdown.seconds = countdown.seconds * 60
            countdown.timer = gears.timer({ timeout = 1 })
            countdown.timer:connect_signal("timeout", function()
                if countdown.seconds > 0 then
                    local minutes = math.floor(countdown.seconds / 60)
                    local seconds = math.fmod(countdown.seconds, 60)
                    countdown.widget:set_markup(string.format("%d:%02d", minutes, seconds))
                    countdown.seconds = countdown.seconds - 1
                else
                    naughty.notify({
                        title = "Countdown",
                        text  = string.format("%s %s timeout", timeout, countdown.minute_t)
                    })
                    countdown.widget:set_markup("")
                    countdown.checkbox.checked = true
                    countdown.timer:stop()
                end
            end)
            countdown.timer:start()
        end
    }
end
countdown.checkbox:buttons(awful.util.table.join(
    awful.button({}, 1, function() countdown.set() end), -- left click
    awful.button({}, 3, function() -- right click
        if countdown.timer and countdown.timer.started then
            countdown.widget:set_markup("")
            countdown.checkbox.checked = false
            countdown.timer:stop()
            naughty.notify({ title = "Countdown", text  = "Timer stopped" })
        end
    end)
))
--]]

-- Wallpapers --{{{1
--[[
local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)
--]]

-- Define the Bar {{{1
awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    -- set_wallpaper(s)

    -- Each screen has its own tag table.
    -- awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])
    awful.tag(tags_list, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.,
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        layout   = {
            -- TODO: icons too small??
            spacing_widget = {
                {
                    forced_width  = 5,
                    forced_height = 24,
                    thickness     = 1,
                    color         = '#777777',
                    widget        = wibox.widget.separator
                },
                valign = 'center',
                halign = 'center',
                widget = wibox.container.place,
            },
            spacing = 1,
            layout  = wibox.layout.fixed.horizontal
        },
        -- Notice that there is *NO* wibox.wibox prefix, it is a template,
        -- not a widget instance.
        widget_template = {
            {
                wibox.widget.base.make_widget(),
                forced_height = 3,
                id            = 'background_role',
                widget        = wibox.container.background,
            },
            {
                {
                    id     = 'clienticon',
                    widget = awful.widget.clienticon,
                },
                margins = 1,
                widget  = wibox.container.margin
            },
            nil,
            create_callback = function(self, c, index, objects) --luacheck: no unused args
                self:get_children_by_id('clienticon')[1].client = c
            end,
            layout = wibox.layout.align.vertical,
        },
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "bottom", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            -- mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            -- mykeyboardlayout,
            wibox.widget.textbox('  ' .. os.getenv("USER")),
            wibox.widget.textbox("  |  "),
            mybattery,
            wibox.widget.textbox("  |  "),
            mybrightness,
            wibox.widget.textbox("  |  "),
            myaudio,
            wibox.widget.textbox("  |  "),
            mytextclock,
            wibox.widget.textbox("  |  "),
            wibox.widget.systray(),
            wibox.widget.textbox("  "),
            s.mylayoutbox,
        },
    }
end)
-- }}}1

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                               Mouse bindings
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

awful.mouse.snap.edge_enabled = false

-- Root window bindings {{{1
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end)
    -- awful.button({ }, 4, awful.tag.viewnext),
    -- awful.button({ }, 5, awful.tag.viewprev)
))

-- Client window bindings {{{1
clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        c.floating = true
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- }}}1

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                                Key bindings
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- Global Bindings {{{1
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    -- Nagivate tags {{{2
	--[[
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
	--]]
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),
    awful.key({ modkey }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    --[[
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    --]]
    --[[
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),
    --]]


    -- Layout manipulation {{{2
    awful.key({ modkey, "Shift" }, "h", function ()
        awful.client.swap.bydirection("left")
    end, {description = "swap with client left", group = "client"}),
    awful.key({ modkey, "Shift" }, "j", function ()
        -- awful.client.swap.bydirection("down")
        awful.client.swap.byidx(1)
    end, {description = "swap with client below", group = "client"}),
    awful.key({ modkey, "Shift" }, "k", function ()
        -- awful.client.swap.bydirection("up")
        awful.client.swap.byidx(-1)
    end, {description = "swap with client above", group = "client"}),
    awful.key({ modkey, "Shift" }, "l", function ()
        awful.client.swap.bydirection("right")
    end, {description = "swap with client right", group = "client"}),
    awful.key({ modkey }, "l", function () awful.tag.incmwfact(master_factor) end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey }, "h", function () awful.tag.incmwfact(-master_factor) end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Control" }, "j", function () awful.client.incwfact(-client_factor) end,
              {description = "decrease client window factor", group = "layout"}),
    awful.key({ modkey, "Control" }, "k", function () awful.client.incwfact(client_factor) end,
              {description = "increase client window factor", group = "layout"}),

    awful.key({modkey, "Control"}, "l", function()
        local master_count = awful.screen.focused().selected_tag.master_count
        if currentClientInMaster() or master_count < 1 then
            awful.tag.incnmaster(1, nil, true)
        else
            awful.tag.incncol(1, nil, true)
        end
    end, {description = "increase number of master or client groups", group = "layout"}),

    awful.key({modkey, "Control"}, "h", function()
        if currentClientInMaster() then
            awful.tag.incnmaster(-1, nil, true)
        else
            awful.tag.incncol(-1, nil, true)
        end
    end, {description = "decrease number of master or client groups", group = "layout"}),
    --[[
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    --]]

    awful.key({ modkey,           }, "space", function ()
        awful.layout.inc(1)  -- TODO always raise current client
    end, {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function ()
        awful.layout.inc(-1) -- TODO always raise current client
    end, {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Standard program {{{2
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Shift"   }, "Return", function () awful.spawn(terminal .. ' --class floaty') end,
              {description = "open a floating terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    --[[
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
    {description = "quit awesome", group = "awesome"}),
    --]]

    -- Prompt {{{2
    awful.key({ modkey }, "d",
              -- function () awful.screen.focused().mypromptbox:run() end,
              function() awful.spawn("dmenu_run -l 20 -p 'Run command:'") end,
              {description = "run prompt", group = "launcher"}),

    -- awful.key({ modkey }, "x",
    --           function ()
    --               awful.prompt.run {
    --                 prompt       = "Run Lua code: ",
    --                 textbox      = awful.screen.focused().mypromptbox.widget,
    --                 exe_callback = awful.util.eval,
    --                 history_path = awful.util.get_cache_dir() .. "/history_eval"
    --               }
    --           end,
    --           {description = "lua execute prompt", group = "awesome"}),
    -- Menubar {{{2
    -- awful.key({ modkey }, "m", function() menubar.show() end,
    --           {description = "show the menubar", group = "launcher"})
    -- Pass menu {{{2
    awful.key({ modkey }, "p", function()
        local pass = 'passmenu'
        pass = pass .. ' -i'
        pass = pass .. ' -nb "#000000" -nf "#aaaaaa"'
        pass = pass .. ' -sb "#555555" -sf "#ffffff"'
        awful.spawn(pass)
    end, {description = "launch 'passmenu'", group = "launcher"}),
    -- clipmenu {{{2
    awful.key({ modkey }, "c", function()
        local clipmenu = 'clipmenu'
        clipmenu = clipmenu .. ' -i'
        awful.spawn(clipmenu)
    end, {description = "launch 'clipmenu'", group = "launcher"}),
    --}}}2
    -- switch screens {{{2
    awful.key({ modkey, alt }, "space", function()
        awful.screen.focus_relative(-1)
    end)
    --}}}2
)

-- Client Bindings {{{1
clientkeys = gears.table.join(
    awful.key({ modkey }, "f", function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
    end, {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift" }, "q", function (c) c:kill() end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space", awful.client.floating.toggle,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey, }, "o", function (c) c:move_to_screen() end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey, }, "t", function (c) c.ontop = not c.ontop end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey, }, "n", function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
    end, {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"})
    --[[
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"}),
    --]]
)

-- Bind all key numbers to tags. {{{1
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
-- awful.tag(tags_list, 1, awful.layout.layouts[1])
-- local sharedtagslist = screen[1].tags
for i = 1, #tags_list do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        -- local tag = sharedtagslist[i]
                        if tag then
                            if screen.selected_tag == tag then
                                awful.tag.history.restore()
                            else
                                awful.tag.setscreen(screen, tag)
                                tag:view_only()
                            end
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end


-- Modes {{{1
-- https://awesomewm.org/doc/api/classes/awful.keygrabber.html

-- Mode for screenshots {{{2
local screenshotgrabber = awful.keygrabber{
    stop_event = 'release',
    stop_key = modkey,
    keybindings = {
        { { modkey }, 's', function() awful.spawn("screenshot.sh") end },
        { { modkey }, 'w', function() awful.spawn("screenshot.sh window") end },
        { { modkey }, 'f', function() awful.spawn("screenshot.sh full") end },
        { { modkey }, 'v', function() awful.spawn("screenshot.sh view") end },
        { { modkey }, 'e', function() awful.spawn("screenshot.sh edit") end },
        { { modkey }, 'r', function() awful.spawn("screenshot.sh resize") end },
    },
    autostart = false,
}
globalkeys = gears.table.join(globalkeys,
    awful.key({ modkey }, 'x', function()
        screenshotgrabber:start()
    end, {description = 'Go into "Screenshot" mode', group = "mode"})
)

-- }}}1

-- Set keys
root.keys(globalkeys)

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                                    Rules
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule. {{{1
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen,
                     sticky = false,
                     maximized = false,
     }
    },

    -- Floating clients. {{{1
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
          "floaty",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer",
          "floaty",
          "Pavucontrol",
          "matplotlib",
        },
        -- Note that the name property shown in xprop might be set slightly
        -- after creation of the client and the name shown there might not
        -- match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs {{{1
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = true }
    },

    -- Move windows to tags {{{1
    { rule = { -- discord
        class = "discord", instance = "discord",
    }, properties = { screen = 1, tag = tags_list[9] } },
    { rule = { -- thunderbird
        class = "Thunderbird", instance = "Mail",
    }, properties = { screen = 1, tag = tags_list[8] } },
    { rule = { -- zoom
        class = "zoom",
    }, properties = { tag = tags_list[7] } },

    -- Program specific rules {{{1
    -- Thunderbird {{{2
    { rule = {
        class = "Thunderbird", role = "messageWindow"
    }, properties = { floating = true } },
    { rule = {
        class = "Thunderbird", role = "Msgcompose"
    }, properties = { floating = true } },
    -- Firefox {{{2
    { rule = {
        class = "firefox", instance = "Places"
    }, properties = { floating = true } },
    -- Flowblade {{{2
    { rule = {
        class = "Flowbladesinglerender", instance = "flowbladesinglerender"
    }, properties = { floating = true } },
    -- Zoom {{{2
    { rule = {
        class = "zoom", name = "Question and Answer",
    }, properties = { floating = true } },
    { rule = {
        class = "zoom", name = "Settings",
    }, properties = { floating = true } },
    -- Chromium {{{2
    {
        rule = { class = "Chromium" },
        except = { instance = "chromium" },
        properties = { floating = false }
    },
    --}}}2

    --}}}1
}

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                                   Signals
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- Signal function to execute when a new client appears. {{{1
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    if not awesome.startup then
        awful.client.setslave(c)
        -- TODO: put client after focussed window
    end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end

    -- hide titlebar
    awful.titlebar.hide(c)

    -- never maxmimuze a window
    c.maximized = false
end)

-- Add a titlebar if titlebars_enabled {{{1
-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse. {{{1
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

-- color for (un)focussed clients {{{1
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- change properties when toggling floating {{{1
client.connect_signal("property::floating", function(c)
    --[[ fullscreen and ontop seem mutually exclusive. Without this check,
         the fullscreen functionality will not work. ]]
    if not c.fullscreen then
        c.ontop = c.floating or false  -- always on top
    end
    -- if c.floating then  -- show titlebar when floating
    --     awful.titlebar.show(c)
    -- else
    --     awful.titlebar.hide(c)
    -- end
end)

-- }}}1

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--                                  Autostart
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

do
    local commands = {
        --"xss-lock ~/bin/screenlock.sh",
        "initscreen.sh",
        --"nm-applet",
        --"clipmenud",
        -- "dunst", -- notifications already provided by 'naughty'
    }

    for _,c in pairs(commands) do
        awful.spawn(c)
    end

    -- Manually run 'collectgarbage' due to 'awesome's memory leak.
    gears.timer{
        autostart = true,
        call_now  = true,
        timeout   = 3600,
        callback  = function() collectgarbage("collect") end
    }
end
