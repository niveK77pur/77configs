# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

from libqtile.config import Key, KeyChord, Screen, Group, Drag, Click, Match
from libqtile.lazy import lazy
from libqtile import qtile
from libqtile import layout, bar, widget
from libqtile import hook

import os
import subprocess

from typing import List  # noqa: F401

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                                   Autostart
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# {{{

# lazy.spawn('initscreen.sh')
#  lazy.spawn(os.path.join(os.path.expanduser('~'), 'bin', 'initscreen.sh'))


@hook.subscribe.startup
def autostart():
    home = os.path.expanduser('~')
    subprocess.call([home + '/.config/qtile/autostart.sh'])


# }}}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                                   Mappings
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# {{{
mod = 'mod4'

keys = [
    # Monad Layout
    Key([mod], 'h', lazy.layout.left()),
    Key([mod], 'l', lazy.layout.right()),
    Key([mod], 'j', lazy.layout.down()),
    Key([mod], 'k', lazy.layout.up()),
    Key([mod, 'shift'], 'h', lazy.layout.swap_left()),
    Key([mod, 'shift'], 'l', lazy.layout.swap_right()),
    Key([mod, 'shift'], 'j', lazy.layout.shuffle_down()),
    Key([mod, 'shift'], 'k', lazy.layout.shuffle_up()),
    Key([mod], 'i', lazy.layout.grow()),
    Key([mod], 'm', lazy.layout.shrink()),
    Key([mod], 'n', lazy.layout.normalize()),
    Key([mod, 'shift'], 'i', lazy.layout.maximize()),
    Key([mod, 'control'], 'space', lazy.layout.flip()),
    # Switch window focus to other pane(s) of stack
    Key([mod], 'space', lazy.layout.next()),
    # Swap panes of split stack
    Key([mod, 'shift'], 'space', lazy.layout.rotate()),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    #  Key([mod], "s", lazy.layout.toggle_split()),
    #  Key([mod, "shift"], "Return", lazy.layout.toggle_split()),
    Key([mod], 'Return', lazy.spawn('wezterm')),
    Key([mod], 'g', lazy.spawn('wezterm start nvim +GhostTextStart')),
    # Toggle between different layouts as defined below
    Key([mod], 'Tab', lazy.next_layout()),
    Key([mod, 'shift'], 'Tab', lazy.prev_layout()),
    Key([mod, 'shift'], 'q', lazy.window.kill()),
    # Toggle fullscreen on window
    Key([mod], 'f', lazy.window.toggle_fullscreen()),
    # Toggle floating on window
    Key([mod, 'shift'], 'f', lazy.window.toggle_floating()),
    # Restart and close qtile
    Key([mod, 'control'], 'r', lazy.restart()),
    Key([mod, 'control'], 'q', lazy.shutdown()),
    # Run commands
    #  Key([mod], "d", lazy.spawncmd(prompt="Run command")),
    Key([mod], 'd', lazy.spawn("dmenu_run -l 20 -p 'Run command:'")),
    # toggle dunst notifications
    Key([mod], 'F1', lazy.spawn('dunst-toggle.sh')),
    Key([mod], 'F2', lazy.spawn('dunstctl history-pop')),
    Key([mod], 'F3', lazy.spawn('dunstctl close')),
    Key([mod, 'shift'], 'F3', lazy.spawn('dunstctl close-all')),
    #  Key Chords --------------------------------------------------------------
    # Take Screenshots
    KeyChord(
        [mod],
        's',
        [
            Key([mod], 's', lazy.spawn('screenshot.sh')),
            Key([mod], 'w', lazy.spawn('screenshot.sh window')),
            Key([mod], 'f', lazy.spawn('screenshot.sh full')),
            Key([mod], 'v', lazy.spawn('screenshot.sh view')),
            Key([mod], 'e', lazy.spawn('screenshot.sh edit')),
            Key([mod], 'r', lazy.spawn('screenshot.sh resize')),
        ],
        mode='Screenshot',
    ),
    # System Operations
    KeyChord(
        [mod],
        'o',
        [
            Key([mod], 'q', lazy.shutdown()),
            # screen brightness
            Key([], '1', lazy.spawn('xbacklight -set  10')),
            Key([], '2', lazy.spawn('xbacklight -set  20')),
            Key([], '3', lazy.spawn('xbacklight -set  30')),
            Key([], '4', lazy.spawn('xbacklight -set  40')),
            Key([], '5', lazy.spawn('xbacklight -set  50')),
            Key([], '6', lazy.spawn('xbacklight -set  60')),
            Key([], '7', lazy.spawn('xbacklight -set  70')),
            Key([], '8', lazy.spawn('xbacklight -set  80')),
            Key([], '9', lazy.spawn('xbacklight -set  90')),
            Key([], '0', lazy.spawn('xbacklight -set 100')),
            # system volume
            Key([mod], 'k', lazy.spawn('amixer -qD pulse sset Master   1%+')),
            Key([mod], 'j', lazy.spawn('amixer -qD pulse sset Master   1%-')),
            Key([mod], 'q', lazy.spawn('amixer -qD pulse sset Master  10%')),
            Key([mod], 'w', lazy.spawn('amixer -qD pulse sset Master  20%')),
            Key([mod], 'e', lazy.spawn('amixer -qD pulse sset Master  30%')),
            Key([mod], 'r', lazy.spawn('amixer -qD pulse sset Master  40%')),
            Key([mod], 't', lazy.spawn('amixer -qD pulse sset Master  50%')),
            Key([mod], 'z', lazy.spawn('amixer -qD pulse sset Master  60%')),
            Key([mod], 'u', lazy.spawn('amixer -qD pulse sset Master  70%')),
            Key([mod], 'i', lazy.spawn('amixer -qD pulse sset Master  80%')),
            Key([mod], 'o', lazy.spawn('amixer -qD pulse sset Master  90%')),
            Key([mod], 'p', lazy.spawn('amixer -qD pulse sset Master 100%')),
            Key([mod], 'm', lazy.spawn('amixer -qD pulse sset Master mute')),
            Key([], 'm', lazy.spawn('amixer -qD pulse sset Master unmute')),
            Key([], 't', lazy.spawn('amixer -qD pulse sset Master toggle')),
            # show system info
            Key([], 'i', lazy.spawn('sysinfo.sh')),
            # poweroff, reboot, suspend. hibernate machine
            Key(['control'], 'p', lazy.spawn('systemctl poweroff')),
            Key(['control'], 'r', lazy.spawn('systemctl reboot')),
            #  Key(['control'], 's', lazy.spawn('i3lock -i ~/Pictures/i3wallpapers/lockscreen/lastofusgiraffe.png && systemctl suspend')),
            Key(['control'], 's', lazy.spawn('systemctl suspend')),
            Key(['control'], 'h', lazy.spawn('i3lock && systemctl hibernate')),
        ],
        mode='System Operations',
    ),
]

#  Drag floating layouts -------------------------------------------------------
mouse = [
    Drag(
        [mod],
        'Button1',
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod],
        'Button3',
        lazy.window.set_size_floating(),
        start=lazy.window.get_size(),
    ),
    Click([mod], 'Button2', lazy.window.bring_to_front()),
]

# }}}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                                    Groups
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# {{{

groups = [Group(i) for i in '1234567890']
for i in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key([mod], i.name, lazy.group[i.name].toscreen()),
            # mod1 + control + letter of group = switch to & move focused window to group
            Key(
                [mod, 'control'],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + letter of group = move focused window to group
            Key([mod, 'shift'], i.name, lazy.window.togroup(i.name)),
        ]
    )

# }}}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                                    Layouts
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# {{{

layout_settings = {
    'margin': 5,
    'border_width': 2,
    'border_focus': '#999999',
    'border_normal': '#000000',
}

layouts = [
    #  layout.Max(),
    #  layout.Stack(num_stacks=2),
    # Try more layouts by unleashing below layouts.
    #  layout.Bsp(),
    #  layout.Columns(),
    #  layout.Matrix(),
    layout.MonadTall(**layout_settings),
    layout.MonadWide(**layout_settings),
    #  layout.RatioTile(),
    #  layout.Tile(),
    layout.TreeTab(**layout_settings),
    #  layout.VerticalTile(),
    #  layout.Zoomy(),
]

# }}}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                                    Widgets
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# {{{

widget_defaults = dict(
    font='victor mono',
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()

widget_list = [
    widget.CurrentLayout(),
    widget.GroupBox(),
    widget.Prompt(),
    widget.WindowName(),
    #  widget.TextBox("default config", name="default"),
    widget.Battery(
        mouse_callbacks={'Button1': lambda: qtile.cmd_spawn('sysinfo.sh')}
    ),
    widget.Sep(),
    widget.Backlight(backlight_name='intel_backlight', fmt=':{}'),
    widget.Volume(fmt='墳:{}'),
    widget.Sep(),
    widget.Systray(),
    widget.Clock(
        format=' %d-%m-%Y %a  %T %z/%Z',
        mouse_callbacks={
            #  'Button1': lambda: qtile.cmd_spawn('alacritty --class floaty --dimensions 125 40 --command less -fR <(curl -s wttr.in)'),
            'Button1': lambda: qtile.cmd_spawn('wttr-display.sh'),
        },
    ),
    #  widget.QuickExit(),
]

# }}}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                                Screen settings
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# {{{
screens = [
    Screen(
        bottom=bar.Bar(
            widget_list,
            24,
        ),
    ),
]
# }}}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                                   Settings
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# {{{
dgroups_key_binder = None
dgroups_app_rules = []

main = None

follow_mouse_focus = True
bring_front_click = False
cursor_warp = False

floating_layout = layout.Floating(
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class='floaty'),
        Match(wm_instance_class='floaty'),
        # Make flowblade's render window float
        #  Match(wm_class="Flowbladesinglerender"),
        Match(
            wm_instance_class='flowbladesinglerender',
            wm_class='Flowbladesinglerender',
        ),
        # Thunderbird
        Match(wm_class='Thunderbird', role='messageWindow'),
        Match(wm_class='Thunderbird', role='Msgcompose'),
        # Firefox
        Match(wm_class='firefox', wm_instance_class='Places'),
        # OpenPGP window
        Match(wm_class='Pinentry-gtk-2'),
    ]
)

auto_fullscreen = True
focus_on_window_activation = 'smart'

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = 'LG3D'
# }}}

# vim: foldmethod=marker
