#     _                      _ _ _        ___  _   _ _
#  __| | __ _ ___ _ __  _ __(_|_| )___   / _ \| |_(_) | ___
# / _` |/ _` / __| '_ \| '__| | |// __| | | | | __| | |/ _ \
#| (_| | (_| \__ \ |_) | |  | | | \__ \ | |_| | |_| | |  __/
# \__,_|\__,_|___/ .__/|_|  |_|_| |___/  \__\_\\__|_|_|\___|
#                |_|
#                  __ _
#  ___ ___  _ __  / _(_) __ _
# / __/ _ \| '_ \| |_| |/ _` |
#| (_| (_) | | | |  _| | (_| |
# \___\___/|_| |_|_| |_|\__, |
#                       |___/
#
# A config for the Qtile (http://www.qtile.org) window manager
#
# Lots taken from Derek Taylor's (http://www.gitlab.com/dwt1/ ) Qtile config with
# modifications to suit my own preferences.
#
# Modified by David Springfield
#

### COPYRIGHT INFO ###
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

### IMPORTS ###
import os
import re
import socket
import subprocess
import logging
from libqtile.config import Key, Screen, Group, Drag, Click
from libqtile.command import lazy
from libqtile import layout, bar, widget, hook
from typing import List  # noqa: F401

### VARIABLES ###
mod = "mod1"                                          # Sets mod key to ALT
term = "termite"                                      # My terminal of choice
myConfig = "/home/dasprii/.config/qtile/config.py"    # The Qtile config file location

### MISC FUNCTIONS ###
# Brings all floating windows to the front
@lazy.function
def float_to_front(qtile):
    logging.info("bring floating windows to front")
    for group in qtile.groups:
        for window in group.windows:
            if window.floating:
                window.cmd_bring_to_front()

### KEYBINDS ###
keys = [
   # General Keybinds
    Key(
        [mod], "Return",
        lazy.spawn(term)
    ),
    Key(
        [mod], "d",
        lazy.spawn("rofi -show")
    ),
    Key(
        [mod], "Tab",
        lazy.next_layout()
    ),
    Key(
        [mod, "shift"], "q",
        lazy.window.kill()
    ),
    Key(
        [mod, "shift"], "r",
        lazy.restart()
    ),
    Key(
        [mod, "shift"], "e",
        lazy.shutdown()
    ),
    # Window Controls
    Key(
        [mod], "k",
        lazy.layout.down(),
        desc='Move focus down in current stack pane'
    ),
    Key(
        [mod], "j",
        lazy.layout.up(),
        desc='Move focus up in current stack pane'
    ),
    Key(
        [mod], "h",
        lazy.layout.shrink(),
    ),
    Key(
        [mod], "l",
        lazy.layout.grow(),
    ),
    Key(
        [mod, "shift"], "k",
        lazy.layout.shuffle_down(),
        desc='Move windows down in current stack'
    ),
    Key(
        [mod, "shift"], "j",
        lazy.layout.shuffle_up(),
        desc='Move windows up in current stack'
    ),  
    Key(
        [mod, "shift"], "space",
        lazy.window.toggle_floating(),
    ),  
    Key(
        [mod], "f",
        lazy.window.toggle_fullscreen(),
    ),  
    Key(
        [mod, "shift"], "Tab",
        lazy.layout.flip(),
    ),
    Key(
        [mod], "r",
        float_to_front
    ),
    # Switch focus to specific monitor (out of three)
    Key(
        [mod], "w",
        lazy.to_screen(0),
        desc='Keyboard focus to monitor 1'
    ),  
    Key(
        [mod], "q",
        lazy.to_screen(1),
        desc='Keyboard focus to monitor 2'
    ),  
    Key(
        [mod], "e",
        lazy.to_screen(2),
        desc='Keyboard focus to monitor 3'
    ),  
    # Screenshot Tool
    Key(
        [], "Print",
        lazy.spawn("flameshot gui"),
    ),
    Key(
        ["shift"], "Print",
        lazy.spawn("flameshot screen"),
    ),
    Key(
        [mod, "shift"], "Print",
        lazy.spawn("flameshot full")
    ),
    # Turn off screen(s)
    Key(
        [mod], "o",
        lazy.spawn("xset dpms force off")
    ),
    # Media controls
    Key(
        [], "XF86AudioRaiseVolume",
        lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +10%"),
    ),
    Key(
        [], "XF86AudioLowerVolume",
        lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -10%"),
    ),
    Key(
        [], "XF86AudioMute",
        lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle"),
    ),
    Key(
        [], "XF86AudioPlay",
        lazy.spawn("playerctl play-pause"),
    ),
    Key(
        [], "XF86AudioNext",
        lazy.spawn("playerctl next"),
    ),
    Key(
        [], "XF86AudioPrev",
        lazy.spawn("playerctl previous"),
    ),
]


### GROUPS ###
group_names = [("WWW", {"layout": "monadtall"}),
               ("STEAM", {"layout": "monadtall"}),
               ("LUTRIS", {"layout": "monadtall"}),
               ("GAME", {"layout": "monadtall"}),
               ("TERM", {"layout": "monadtall"}),
               ("FILE", {"layout": "monadtall"}),
               ("DOC", {"layout": "monadtall"}),
               ("OBS", {"layout": "monadtall"}),
               ("MISC", {"layout": "monadtall"})]

groups = [Group(name, **kwargs) for name, kwargs in group_names]

for i, (name, kwargs) in enumerate(group_names, 1):
    keys.append(Key([mod], str(i), lazy.group[name].toscreen()))        # Switch to another group
    keys.append(Key([mod, "shift"], str(i), lazy.window.togroup(name))) # Send current window to another group	

### DEFAULT THEME SETTINGS FOR LAYOUTS ###
layout_theme = {"border_width": 2,
                "margin": 10,
                "border_focus" : "#5e81ac",
                "border_normal": "#3b4252"
                }

### LAYOUTS ###
layouts = [
    layout.MonadTall(**layout_theme),
    layout.Floating(**layout_theme)
]

### COLORS ###
#colors = [["#282a36", "#282a36"], # panel background
#          ["#44475a", "#44475a"], # background for current screen tab
#          ["#f8f8f2", "#f8f8f2"], # font color for group names
#          ["#8be9fd", "#8be9fd"], # border line color for current tab
#          ["#6272a4", "#6272a4"], # border line color for other tab and odd widgets
#          ["#bd93f9", "#bd93f9"], # color for the even widgets
#          ["#50fa7b", "#50fa7b"]] # window name

# Dracula Color Theme
#colors = [["#282a36", "#282a36"], # Background                [0]
#          ["#44475a", "#44475a"], # Current Line / Selection  [1]
#          ["#f8f8f2", "#f8f8f2"], # Foreground                [2]
#          ["#6272a4", "#6272a4"], # Comment                   [3]
#          ["#8be9fd", "#8be9fd"], # Cyan                      [4]
#          ["#50fa7b", "#50fa7b"], # Green                     [5]
#          ["#ffb86c", "#ffb86c"], # Orange                    [6]
#          ["#ff79c6", "#ff79c6"], # Pink                      [7]
#          ["#bd93f9", "#bd93f9"], # Purple                    [8]
#          ["#ff5555", "#ff5555"], # Red                       [9]
#          ["#f1fa8c", "#f1fa8c"]] # Yellow                    [10]

# Nord Color Theme
colors = [["#2e3440", "#2e3440"], #nord0
          ["#3b4252", "#3b4252"], #nord1
          ["#434c5e", "#434c5e"], #nord2
          ["#4c566a", "#4c566a"], #nord3
          ["#d8dee9", "#d8dee9"], #nord4
          ["#e5e9f0", "#e5e9f0"], #nord5
          ["#eceff4", "#eceff4"], #nord6
          ["#8fbcbb", "#8fbcbb"], #nord7
          ["#88c0d0", "#88c0d0"], #nord8
          ["#81a1c1", "#81a1c1"], #nord9
          ["#5e81ac", "#5e81ac"], #nord10
          ["#bf616a", "#bf616a"], #nord11
          ["#d08770", "#d08770"], #nord12
          ["#ebcb8b", "#ebcb8b"], #nord13
          ["#a3be8c", "#a3be8c"], #nord14
          ["#b48ead", "#b48ead"]] #nord15

#
### PROMPT ###
prompt = "{0}@{1}: ".format(os.environ["USER"], socket.gethostname())

### DEFAULT WIDGET SETTINGS ###
widget_defaults = dict(
    font="Ubuntu Regular",
    fontsize = 12,
    padding = 2,
    background=colors[0]
)
extension_defaults = widget_defaults.copy()

### WIDGETS ###

def init_widgets_list():
    widgets_list = [
               widget.Sep(
                        linewidth = 0,
                        padding = 6,
                        foreground = colors[6],
                        background = colors[0]
                        ),
               widget.GroupBox(font="Ubuntu Regular",
                        fontsize = 11,
                        margin_y = 3,
                        margin_x = 0,
                        padding_y = 5,
                        padding_x = 5,
                        borderwidth = 3,
                        active = colors[6],
                        inactive = colors[6],
                        rounded = False,
                        highlight_color = colors[3],
                        highlight_method = "block",
                        this_current_screen_border = colors[3],
                        this_screen_border = colors [0],
                        other_current_screen_border = colors[0],
                        other_screen_border = colors[0],
                        foreground = colors[6],
                        background = colors[0]
                        ),
               widget.Sep(
                        linewidth = 0,
                        padding = 40,
                        ),
               widget.WindowName(
                        foreground = colors[14],
                        background = colors[0],
                        padding = 0
                        ),
               widget.TextBox(
                        text='',
                        background = colors[0],
                        foreground = colors[7],
                        padding=0,
                        fontsize=37
                        ),
               widget.TextBox(
                        text=" ",
                        padding = 0,
                        foreground=colors[0],
                        background=colors[7],
                        fontsize=12
                        ),
               widget.CPU(
                        format='CPU {freq_current}GHz {load_percent}%',
                        update_interval=1.0,
                        foreground=colors[0],
                        background=colors[7],
                        padding = 5
                        ),
               widget.TextBox(
                        text='',
                        background = colors[7],
                        foreground = colors[10],
                        padding=0,
                        fontsize=37
                        ),
               widget.TextBox(
                        text=" 🌡",
                        padding = 2,
                        foreground=colors[0],
                        background=colors[10],
                        fontsize=11
                        ),
               widget.ThermalSensor(
                        foreground=colors[0],
                        background=colors[10],
                        padding = 5,
                        tag_sensor = "Tdie"
                        ),
               widget.TextBox(
                        text='',
                        background = colors[10],
                        foreground = colors[8],
                        padding=0,
                        fontsize=37
                        ),
               widget.TextBox(
                        text=" 🖬",
                        foreground=colors[0],
                        background=colors[8],
                        padding = 0,
                        fontsize=14
                        ),
               widget.Memory(
                        foreground = colors[0],
                        background = colors[8],
                        padding = 5
                        ),
               widget.TextBox(
                        text='',
                        background = colors[8],
                        foreground = colors[9],
                        padding=0,
                        fontsize=37
                        ),
               widget.Net(
                        interface = "enp34s0",
                        format = '{down} ↓↑ {up}',
                        foreground = colors[0],
                        background = colors[9],
                        padding = 5
                        ),
               widget.TextBox(
                        text='',
                        background = colors[9],
                        foreground = colors[7],
                        padding=0,
                        fontsize=37
                        ),
               widget.TextBox(
                       text=" Vol:",
                        foreground=colors[0],
                        background=colors[7],
                        padding = 0
                        ),
               widget.Volume(
                        foreground = colors[0],
                        background = colors[7],
                        padding = 5
                        ),
               widget.TextBox(
                        text='',
                        background = colors[7],
                        foreground = colors[10],
                        padding=0,
                        fontsize=37
                        ),
               widget.CurrentLayout(
                        foreground = colors[0],
                        background = colors[10],
                        padding = 5
                        ),
               widget.TextBox(
                        text='',
                        background = colors[10],
                        foreground = colors[8],
                        padding=0,
                        fontsize=37
                        ),
               widget.Clock(
                        foreground = colors[0],
                        background = colors[8],
                        format="%A, %B %d  [ %I:%M %p ]"
                        ),
              ]
    return widgets_list

### SCREENS ### (TRIPLE MONITOR SETUP)

def init_widgets_screen1():
    widgets_screen1 = init_widgets_list()
    return widgets_screen1                       # Slicing removes unwanted widgets on Monitors 1,3

def init_widgets_screen2():
    widgets_screen2 = init_widgets_list()
    return widgets_screen2                       # Monitor 2 will display all widgets in widgets_list

def init_screens():
    return [Screen(top=bar.Bar(widgets=init_widgets_screen1(), opacity=0.95, size=20)),
            Screen(top=bar.Bar(widgets=init_widgets_screen2(), opacity=0.95, size=20)),
            Screen(top=bar.Bar(widgets=init_widgets_screen1(), opacity=0.95, size=20))]

if __name__ in ["config", "__main__"]:
    screens = init_screens()
    widgets_list = init_widgets_list()
    widgets_screen1 = init_widgets_screen1()
    widgets_screen2 = init_widgets_screen2()

### DRAG FLOATING WINDOWS ###
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
main = None
follow_mouse_focus = True
bring_front_click = True
cursor_warp = False

### FLOATING WINDOWS ###
floating_layout = layout.Floating(**layout_theme, float_rules=[
    {'wmclass': 'confirm'},
    {'wmclass': 'dialog'},
    {'wmclass': 'download'},
    {'wmclass': 'error'},
    {'wmclass': 'file_progress'},
    {'wmclass': 'notification'},
    {'wmclass': 'splash'},
    {'wmclass': 'toolbar'},
    {'wmclass': 'confirmreset'},  # gitk
    {'wmclass': 'makebranch'},  # gitk
    {'wmclass': 'maketag'},  # gitk
    {'wname': 'branchdialog'},  # gitk
    {'wname': 'pinentry'},  # GPG key password entry
    {'wmclass': 'ssh-askpass'},  # ssh-askpass
    {'wmclass': 'Lxappearance'},
    {'wmclass': 'Pavucontrol'},
    {'wmclass': 'VirtualBox Manager'},
    {'wmclass': 'Lutris'},
    {'wmclass': 'Wine'},
    {'wmclass': 'Thunar'},
    {'wmclass': 'net-technicpack-launcher-LauncherMain'},
    {'wmclass': 'Blueman-manager'},
    {'wmclass': 'feh'},
    {'wmclass': 'Lxpolkit'},
    {'wmclass': 'Timeshift-gtk'},
    {'wmclass': 'cemu.exe'},
    {'wmclass': 'origin.exe'},
    {'wmclass': 'explorer.exe'},
    {'wmclass': 'ffxivlauncher.exe'},
])

# Steam specific floating settings
@hook.subscribe.client_new
def float_steam(window):
    wm_class = window.window.get_wm_class()
    w_name = window.window.get_name()
    if (
        wm_class == ("Steam", "Steam")
        and (
            w_name != "Steam"
            # w_name == "Friends List"
            # or w_name == "Screenshot Uploader"
            # or w_name.startswith("Steam - News")
            or "PMaxSize" in window.window.get_wm_normal_hints().get("flags", ())
        )
    ):
        window.floating = True

auto_fullscreen = True
focus_on_window_activation = "smart"

### STARTUP APPLICATIONS ###
@hook.subscribe.startup_once
def start_once():
    home = os.path.expanduser('~')
    subprocess.call([home + '/.config/qtile/autostart.sh'])

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
