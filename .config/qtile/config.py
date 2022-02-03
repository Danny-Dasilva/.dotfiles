from typing import List  # noqa: F401

# from typing import Enum

from libqtile import bar, layout, hook, widget
from libqtile.config import Click, Drag, Group, Key, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from libqtile.config import Match
import os
from libqtile import qtile
from libqtile.config import (
    KeyChord,
    Key,
    Screen,
    Group,
    Drag,
    Click,
    ScratchPad,
    DropDown,
    Match,
)
from custom.pomodoro import Pomodoro as CustomPomodoro
import socket
from pathlib import Path
import subprocess
from time import time

mod = "mod4"
terminal = guess_terminal()


def screenshot(save=True, copy=True):
    def f(qtile):
        path = Path.home() / "Pictures"
        path /= f"screenshot_{str(int(time() * 100))}.png"
        shot = subprocess.run(["maim"], stdout=subprocess.PIPE)

        if save:
            with open(path, "wb") as sc:
                sc.write(shot.stdout)

        if copy:
            subprocess.run(
                ["xclip", "-selection", "clipboard", "-t", "image/png"],
                input=shot.stdout,
            )

    return f


def backlight(action):
    def f(qtile):
        brightness = int(
            subprocess.run(["xbacklight", "-get"], stdout=subprocess.PIPE).stdout
        )
        if brightness != 1 or action != "dec":
            if (brightness > 49 and action == "dec") or (
                brightness > 39 and action == "inc"
            ):
                subprocess.run(["xbacklight", f"-{action}", "10", "-fps", "10"])
            else:
                subprocess.run(["xbacklight", f"-{action}", "1"])

    return f


# Define functions for bar
def taskwarrior():
    return (
        subprocess.check_output(["./.config/qtile/task_polybar.sh"])
        .decode("utf-8")
        .strip()
    )


def finish_task():
    qtile.cmd_spawn('task "$((`cat /tmp/tw_polybar_id`))" done')


def update():
    qtile.cmd_spawn(terminal + "-e yay")


def open_alsa():
    qtile.cmd_spawn("alsamixer")


def toggle_bluetooth():
    qtile.cmd_spawn("./.config/qtile/system-bluetooth-bluetoothctl.sh --toggle")


def open_bt_menu():
    qtile.cmd_spawn("blueman")


def bluetooth():
    return (
        subprocess.check_output(["./.config/qtile/system-bluetooth-bluetoothctl.sh"])
        .decode("utf-8")
        .strip()
    )


def open_powermenu():
    qtile.cmd_spawn("./.config/rofi/powermenu/powermenu.sh")


def open_nmtui():
    qtile.cmd_spawn("nmtui")


keys = [
    # Switch between windows
    Key([mod, "shift"], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod, "shift"], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod, "shift"], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod, "shift"], "k", lazy.layout.up(), desc="Move focus up"),
    Key(
        [mod, "shift"],
        "space",
        lazy.layout.next(),
        desc="Move window focus to other window",
    ),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key(
        [mod, "control"],
        "h",
        lazy.layout.shuffle_left(),
        desc="Move window to the left",
    ),
    Key(
        [mod, "control"],
        "l",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    Key([mod, "control"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "control"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod], "Left", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod], "Right", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod], "Down", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod], "Up", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "control"], "r", lazy.restart(), desc="Restart Qtile"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    Key([], "XF86MonBrightnessUp", lazy.function(backlight("inc"))),
    Key([], "XF86MonBrightnessDown", lazy.function(backlight("dec"))),
    Key([mod], "F3", lazy.spawn("amixer set 'Master' 1%+"), desc="volume up 1%"),
    Key([mod], "F2", lazy.spawn("amixer set 'Master' 1%-"), desc="volume up 1%"),
    Key(
        [mod], "F1", lazy.spawn("amixer set 'Master' toggle"), desc="Volume mute toggle"
    ),
    Key([mod], "v", lazy.spawn("xterm alsamixer"), desc="change volume settings"),
]


def show_keys():
    key_help = ""
    for k in keys:
        mods = ""

        for m in k.modifiers:
            if m == "mod4":
                mods += "Super + "
            else:
                mods += m.capitalize() + " + "

        if len(k.key) > 1:
            mods += k.key.capitalize()
        else:
            mods += k.key

        key_help += "{:<30} {}".format(mods, k.desc + "\n")

    return key_help


keys.extend(
    [
        Key(
            [mod],
            "a",
            lazy.spawn(
                "sh -c 'echo \""
                + show_keys()
                + '" | rofi -dmenu -theme ~/.config/rofi/configTall.rasi -i -p "?"\''
            ),
            desc="Print keyboard bindings",
        ),
    ]
)

workspaces = [
    {"name": "", "key": "1", "matches": [Match(wm_class="firefox")]},
    {
        "name": "",
        "key": "2",
        "matches": [Match(wm_class="Thunderbird"), Match(wm_class="ptask")],
    },
    {"name": "", "key": "3", "matches": []},
    {"name": "", "key": "4", "matches": [Match(wm_class="vim")]},
    {"name": "", "key": "5", "matches": []},
    {"name": "", "key": "6", "matches": [Match(wm_class="slack")]},
    {"name": "", "key": "7", "matches": [Match(wm_class="spotify")]},
    {"name": "", "key": "8", "matches": [Match(wm_class="zoom")]},
    {"name": "", "key": "9", "matches": [Match(wm_class="gimp")]},
    {
        "name": "",
        "key": "0",
        "matches": [Match(wm_class="lxappearance"), Match(wm_class="pavucontrol")],
    },
]

groups = [
    ScratchPad(
        "scratchpad",
        [
            # define a drop down terminal.
            # it is placed in the upper third of screen by default.
            DropDown(
                "term",
                "urxvt -e tmux_startup.sh",
                height=0.6,
                on_focus_lost_hide=False,
                opacity=1,
                warp_pointer=False,
            )
        ],
    ),
]

for workspace in workspaces:
    matches = workspace["matches"] if "matches" in workspace else None
    groups.append(Group(workspace["name"], layout="Bsp"))
    keys.append(
        Key(
            [mod],
            workspace["key"],
            lazy.group[workspace["name"]].toscreen(),
            desc="Focus this desktop",
        )
    )
    keys.append(
        Key(
            [mod, "shift"],
            workspace["key"],
            lazy.window.togroup(workspace["name"]),
            desc="Move focused window to another group",
        )
    )
layout_theme = {
    "border_width": 2,
    "margin": 6,
    "border_focus": "5e81ac",
    "border_normal": "4c566a",
}
layouts = [
    layout.Columns(**layout_theme),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
    # layout.MonadTall(**layout_theme),
    # layout.Tile(shift_windows=True, **layout_theme),
    # layout.Stack(num_stacks=2),
    layout.Max(**layout_theme),
]

from enum import Enum


class Colors(Enum):
    background = "#2e3440"  # background
    foreground = "#d8dee9"  # foreground
    background_lighter = "#3b4252"  # background lighter
    red = "#bf616a"  # red
    green = "#a3be8c"  # green
    yellow = "#ebcb8b"  # yellow
    blue = "#81a1c1"  # blue
    magenta = "#b48ead"  # magenta
    cyan = "#88c0d0"  # cyan
    white = "#e5e9f0"  # white
    grey = "#4c566a"  # grey
    orange = "#d08770"  # orange
    super_cyan = "#8fbcbb"  # super cyan
    super_blue = "#5e81ac"  # super blue
    dark_background = "#242831"  # super dark background


colors = [
    ["#2e3440", "#2e3440"],  # background
    ["#d8dee9", "#d8dee9"],  # foreground
    ["#3b4252", "#3b4252"],  # background lighter
    ["#bf616a", "#bf616a"],  # red
    ["#a3be8c", "#a3be8c"],  # green
    ["#ebcb8b", "#ebcb8b"],  # yellow
    ["#81a1c1", "#81a1c1"],  # blue
    ["#b48ead", "#b48ead"],  # magenta
    ["#88c0d0", "#88c0d0"],  # cyan
    ["#e5e9f0", "#e5e9f0"],  # white
    ["#4c566a", "#4c566a"],  # grey
    ["#d08770", "#d08770"],  # orange
    ["#8fbcbb", "#8fbcbb"],  # super cyan
    ["#5e81ac", "#5e81ac"],  # super blue
    ["#242831", "#242831"],  # super dark background
]
widget_defaults = dict(
    font="Fira Code iCursive  S12", fontsize=12, padding=3, background=colors[0]
)
extension_defaults = widget_defaults.copy()

group_box_settings = {
    "padding": 5,
    "borderwidth": 4,
    "active": colors[9],
    "inactive": colors[10],
    "disable_drag": True,
    "rounded": True,
    "highlight_color": colors[2],
    "block_highlight_text_color": colors[6],
    "highlight_method": "block",
    "this_current_screen_border": colors[14],
    "this_screen_border": colors[7],
    "other_current_screen_border": colors[14],
    "other_screen_border": colors[14],
    "foreground": colors[1],
    "background": colors[14],
    "urgent_border": colors[3],
    "fontsize": 20,
}

from libqtile.widget.base import _TextBox
from libqtile.widget import Volume, Net, Clock
from qtile_extras.bar import Bar
from qtile_extras.widget import modify
from qtile_extras.widget.decorations import RectDecoration, BorderDecoration


class Round(Enum):
    right = [13, 0, 0, 13]
    left = [0, 13, 13, 0]
    none = 13


class BaseCustomWidget:
    def __init__(
        self,
        widget,
        background: Colors,
        foreground: Colors,
        round_corner: Round,
        fontsize: int = 22,
        **kwargs,
    ):
        self.radius = 13
        self.padding = 2
        return modify(
            widget,
            fontsize=fontsize,
            foreground=foreground.value if foreground else None,
            decorations=[
                RectDecoration(
                    colour=background.value,
                    radius=round_corner.value,
                    filled=True,
                    padding_y=self.padding,
                )
            ],
            **kwargs,
        )


class CustomClock(BaseCustomWidget):
    def __init__(self, **kwargs):
        widget = Clock
        return super().__init__(widget, **kwargs)


def custom_modify(
    widget,
    background: Colors,
    foreground: Colors,
    round_corner: Round,
    fontsize: int = 22,
    **kwargs,
):
    padding = 2
    return modify(
            widget,
            fontsize=fontsize,
            foreground=foreground.value if foreground else None,
            decorations=[
                RectDecoration(
                    colour=background.value,
                    radius=round_corner.value,
                    filled=True,
                    padding_y=padding,
                )
            ],
            **kwargs,
        )

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.TextBox(
                    text="",
                    foreground="#ff005f",
                    background=colors[0],
                    font="Font Awesome 5 Free Solid",
                    fontsize=22,
                    padding=20,
                ),
                widget.TextBox(
                    text="",
                    foreground=colors[14],
                    background=colors[0],
                    fontsize=22,
                    padding=0,
                ),
                widget.GroupBox(
                    font="Font Awesome 5 Brands",
                    visible_groups=[""],
                    **group_box_settings,
                ),
                widget.GroupBox(
                    font="Font Awesome 5 Free Solid",
                    visible_groups=["", "", "", "", ""],
                    **group_box_settings,
                ),
                widget.GroupBox(
                    font="Font Awesome 5 Brands",
                    visible_groups=[""],
                    **group_box_settings,
                ),
                widget.GroupBox(
                    font="Font Awesome 5 Free Solid",
                    visible_groups=["", "", ""],
                    **group_box_settings,
                ),
                widget.TextBox(
                    text="",
                    foreground=colors[14],
                    background=colors[0],
                    fontsize=22,
                    padding=0,
                ),
                widget.Sep(
                    linewidth=0,
                    foreground=colors[2],
                    background=colors[0],
                    padding=10,
                    size_percent=40,
                ),
                # widget.TextBox(
                #    text=" ",
                #    foreground=colors[7],
                #    background=colors[0],
                #    font="Font Awesome 5 Free Solid",
                # ),
                # widget.CurrentLayout(
                #    background=colors[0],
                #    foreground=colors[7],
                # ),
                widget.TextBox(
                    text="",
                    foreground=colors[14],
                    background=colors[0],
                    fontsize=22,
                    padding=0,
                ),
                widget.CurrentLayoutIcon(
                    custom_icon_paths=[os.path.expanduser("~/.config/qtile/icons")],
                    foreground=colors[2],
                    background=colors[14],
                    padding=-2,
                    scale=0.45,
                ),
                widget.TextBox(
                    text="",
                    foreground=colors[14],
                    background=colors[0],
                    fontsize=22,
                    padding=0,
                ),
                widget.Sep(
                    linewidth=0,
                    foreground=colors[2],
                    padding=10,
                    size_percent=50,
                ),
                widget.TextBox(
                    text="",
                    foreground=colors[14],
                    background=colors[0],
                    fontsize=22,
                    padding=0,
                ),
                widget.GenPollText(
                    func=taskwarrior,
                    update_interval=5,
                    foreground=colors[11],
                    background=colors[14],
                    mouse_callbacks={"Button1": finish_task},
                ),
                widget.TextBox(
                    text="",
                    foreground=colors[14],
                    background=colors[0],
                    fontsize=22,
                    padding=0,
                ),
                widget.Spacer(),
                widget.Prompt(foreground="#ff005f", background=colors[0], padding=0),
                custom_modify(
                    widget=_TextBox,
                    text=" ",
                    background=Colors.background,
                    foreground=Colors.cyan,
                    round_corner=Round.none,
                    fontsize=20,
                ),
                widget.WindowName(
                    background=colors[0],
                    foreground=colors[12],
                    width=bar.CALCULATED,
                    empty_group_string="Desktop",
                ),
                widget.CheckUpdates(
                    background=colors[0],
                    foreground=colors[3],
                    colour_have_updates=colors[3],
                    custom_command="./.config/qtile/updates-arch-combined",
                    display_format=" {updates}",
                    execute=update,
                    padding=20,
                ),
                widget.Spacer(),
                widget.TextBox(
                    text="",
                    foreground=colors[14],
                    background=colors[0],
                    fontsize=22,
                    padding=0,
                ),
                CustomPomodoro(
                    background=colors[14],
                    fontsize=24,
                    color_active=colors[3],
                    color_break=colors[6],
                    color_inactive=colors[10],
                    timer_visible=False,
                    prefix_active="",
                    prefix_break="",
                    prefix_inactive="",
                    prefix_long_break="",
                    prefix_paused="",
                ),
                widget.TextBox(
                    text="",
                    foreground=colors[14],
                    background=colors[0],
                    fontsize=22,
                    padding=0,
                ),
                widget.Sep(
                    linewidth=0,
                    foreground=colors[2],
                    padding=10,
                    size_percent=50,
                ),
                custom_modify(
                    widget=_TextBox,
                    text=" ",
                    background=Colors.dark_background,
                    foreground=Colors.cyan,
                    round_corner=Round.right,
                ),
                custom_modify(
                    widget=Volume,
                    background=Colors.dark_background,
                    foreground=Colors.cyan,
                    round_corner=Round.left,
                    mouse_callbacks={"Button3": open_alsa},
                    fontsize=13,
                ),
                widget.Sep(
                    linewidth=0,
                    foreground=colors[2],
                    padding=10,
                    size_percent=50,
                ),
                custom_modify(
                    widget=_TextBox,
                    text="  ",
                    background=Colors.dark_background,
                    foreground=Colors.magenta,
                    round_corner=Round.right,
                ),
                custom_modify(
                    widget=Net,
                    interface="wlp3s0",
                    format="{down} ↓↑ {up}",
                    background=Colors.dark_background,
                    foreground=Colors.magenta,
                    padding=10,
                    round_corner=Round.left,
                    fontsize=12
                    #    mouse_callbacks={"Button1": open_nmtui},
                ),
                widget.Sep(
                    linewidth=0,
                    foreground=colors[2],
                    padding=10,
                    size_percent=50,
                ),
                custom_modify(
                    widget=_TextBox,
                    text=" ",
                    background=Colors.dark_background,
                    foreground=Colors.yellow,
                    round_corner=Round.right,
                ),
                custom_modify(
                    widget=Clock,
                    format="%a, %b %d",
                    background=Colors.dark_background,
                    foreground=Colors.yellow,
                    round_corner=Round.left,
                    padding=10,
                    fontsize=12,
                ),
                widget.Sep(
                    linewidth=0,
                    foreground=colors[2],
                    padding=10,
                    size_percent=50,
                ),
                custom_modify(
                    widget=_TextBox,
                    text=" ",
                    background=Colors.dark_background,
                    foreground=Colors.green,
                    round_corner=Round.right,
                ),
                custom_modify(
                    widget=Clock,
                    format="%a, %b %d",
                    background=Colors.dark_background,
                    foreground=Colors.green,
                    round_corner=Round.left,
                    padding=10,
                    fontsize=12,
                ),
                widget.TextBox(
                    text="⏻",
                    foreground=colors[13],
                    fontsize=20,
                    padding=20,
                    mouse_callbacks={"Button1": open_powermenu},
                ),
            ],
            30,
            border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            border_color=[
                "2e3440",
                "000000",
                "2e3440",
                "000000",
            ],  # Borders are magenta
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
main = None  # WARNING: this is deprecated and will be removed soon
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
# floating_layout = layout.Floating( #float_rules=[
# Run the utility of `xprop` to see the wm class and name of an X client.
# {'wmclass': 'confirm'},
# {'wmclass': 'dialog'},
# {'wmclass': 'download'},
# {'wmclass': 'error'},
# {'wmclass': 'file_progress'},
# {'wmclass': 'notification'},
# {'wmclass': 'splash'},
# {'wmclass': 'toolbar'},
# {'wmclass': 'confirmreset'},  # gitk
# {'wmclass': 'makebranch'},  # gitk
# {'wmclass': 'maketag'},  # gitk
# {'wname': 'branchdialog'},  # gitk
# {'wname': 'pinentry'},  # GPG key password entry
# {'wmclass': 'ssh-askpass'},  # ssh-askpass
# ],
# **layout_theme)
auto_fullscreen = True
focus_on_window_activation = "smart"

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "Qtile"
