------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = 1.25,
})

-- Dual monitor example on G15 Strix
-- eDP-1 is the built in monitor while DP-1 is external
-- Both monitors here are at 1440 and 165Hz
-- DP-1 is on the left and eDP-1 is on the right
-- hl.monitor({ output = "DP-1",  mode = "2560x1440@165", position = "0x0",    scale = 1 })
-- hl.monitor({ output = "eDP-1", mode = "2560x1440@165", position = "2560x0", scale = 1 })


---------------------
---- MY PROGRAMS ----
---------------------

local terminal    = "kitty"
local fileManager = "thunar"
local menu        = "wofi"
local home        = os.getenv("HOME")


-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    hl.exec_cmd(home .. "/.config/hypr/xdg-portal-hyprland")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    hl.exec_cmd("waybar")
    hl.exec_cmd("swaybg -m fill -i " .. home .. "/.config/hypr/gargantuaRed.png")
end)

-- Split this config into multiple files with:
-- require("myColors")


-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = 20,

        border_size = 2,

        col = {
            active_border   = { colors = { "rgba(ff3333ee)", "rgba(990000ee)" } },
            inactive_border = "rgba(595959aa)",
        },

        layout = "dwindle",
    },

    decoration = {
        rounding = 10,

        blur = {
            enabled = true,
            size    = 7,
            passes  = 3,
        },
    },

    misc = {
        disable_hyprland_logo   = true,
        disable_watchdog_warning = true,
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        preserve_split = true,
    },

    master = {
        new_status = "master",
    },

    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = false,
        },
    },
})

hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

hl.animation({ leaf = "windows",    enabled = true, speed = 7,  bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7,  bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border",     enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "fade",       enabled = true, speed = 7,  bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6,  bezier = "default" })

hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- Transparency rules
local transparency = {
    { name = "opacity-kitty",     class = "^(kitty)$",                     opacity = 0.8 },
    { name = "opacity-thunar",    class = "^(thunar)$",                    opacity = 0.8 },
    { name = "opacity-firefox",   class = "^(firefox)$",                   opacity = 0.8 },
    { name = "opacity-firefox-d", class = "^(firefox-developer-edition)$", opacity = 0.9 },
    { name = "opacity-code",      class = "^(code)$",                      opacity = 0.7 },
}

for _, rule in ipairs(transparency) do
    hl.window_rule({
        name  = rule.name,
        match = { class = rule.class },

        opacity = rule.opacity,
    })
end


---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

hl.bind(mainMod .. " + Q",         hl.dsp.exec_cmd(terminal))                          -- open the terminal
hl.bind(mainMod .. " + SHIFT + X", hl.dsp.window.close())                              -- close the active window
hl.bind(mainMod .. " + L",         hl.dsp.exec_cmd("swaylock"))                        -- lock the screen
hl.bind(mainMod .. " + M",         hl.dsp.exec_cmd("wlogout --protocol layer-shell"))  -- show the logout window
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exit())                                      -- exit Hyprland altogether
hl.bind(mainMod .. " + E",         hl.dsp.exec_cmd(fileManager))                       -- graphical file browser
hl.bind(mainMod .. " + V",         hl.dsp.window.float({ action = "toggle" }))         -- allow a window to float
hl.bind(mainMod .. " + SPACE",     hl.dsp.exec_cmd(menu))                              -- graphical app launcher
hl.bind(mainMod .. " + P",         hl.dsp.window.pseudo())                             -- dwindle
hl.bind(mainMod .. " + J",         hl.dsp.layout("togglesplit"))                       -- dwindle
hl.bind(mainMod .. " + S",         hl.dsp.exec_cmd('grim -g "$(slurp)" - | swappy -f -')) -- take a screenshot
hl.bind(mainMod .. " + F",         hl.dsp.window.fullscreen())                         -- toggle fullscreen
hl.bind(mainMod .. " + C",         hl.dsp.exec_cmd("code"))                            -- open VSCode


-- ROG G15 Strix (2021) specific binds
-- hl.bind("code:156", hl.dsp.exec_cmd("rog-control-center"))                                      -- ASUS Armory Crate key
-- hl.bind("code:211", hl.dsp.exec_cmd("asusctl profile -n; pkill -SIGRTMIN+8 waybar"))            -- fan profile switch
hl.bind("F3", hl.dsp.exec_cmd("pamixer -t"))                  -- speaker mute
hl.bind("F4", hl.dsp.exec_cmd("pamixer -d 5"))                -- volume down
hl.bind("F5", hl.dsp.exec_cmd("pamixer -i 5"))                -- volume up
hl.bind("F6", hl.dsp.exec_cmd("brightnessctl set 5%-"))       -- brightness down
hl.bind("F7", hl.dsp.exec_cmd("brightnessctl set +5%"))       -- brightness up
-- hl.bind("code:256", hl.dsp.exec_cmd("pamixer --default-source -t"))                             -- mic mute
-- hl.bind("code:237", hl.dsp.exec_cmd("brightnessctl -d asus::kbd_backlight set 33%-"))           -- kbd brightness down
-- hl.bind("code:238", hl.dsp.exec_cmd("brightnessctl -d asus::kbd_backlight set 33%+"))           -- kbd brightness up
-- hl.bind("code:210", hl.dsp.exec_cmd("asusctl led-mode -n"))                                     -- kbd RGB profile

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
