<div align="center">

# 🪐 Arch Nemesis

### A Wayland / Hyprland rice, tracked in place as `~/.config`

![Arch](https://img.shields.io/badge/Arch_Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white)
![Hyprland](https://img.shields.io/badge/Hyprland-00AAAE?style=for-the-badge&logo=wayland&logoColor=white)
![Wayland](https://img.shields.io/badge/Wayland-FFBC00?style=for-the-badge&logo=wayland&logoColor=black)

_No stow, no symlink farm — this directory **is** the repo._

</div>

---

## ✨ What's inside

| Component          | Program                                  |
| ------------------- | ----------------------------------------- |
| **Compositor**      | Hyprland (config authored in Lua, compiled to `hyprland.conf`) |
| **Bar**              | Waybar, with a custom wttr.in weather module |
| **Terminal**         | kitty, Catppuccin Mocha palette           |
| **Launcher**         | wofi                                      |
| **Notifications**    | mako                                      |
| **Lock screen**      | swaylock                                  |
| **Logout menu**      | wlogout                                   |
| **File manager**     | Thunar                                    |
| **Wallpaper**        | swaybg                                    |
| **Shell prompt**     | starship                                  |
| **Audio visualizer** | cava, with hand-written GLSL shaders — see below |
| **System info**      | fastfetch (Tokyo Night) · neofetch (animated variant) |

---

## 🎛️ cava shaders

[`cava/shaders/`](cava/shaders/) holds hand-written GLSL fragment shaders rendering the
audio spectrum, selectable in [`cava/config`](cava/config):

- `orion_circle` / `orion_circle_rotate` — radial spectrum rings
- `orion_saturn_core` / `orion_saturn_subring` — layered ringed-planet visualization
- `eye_of_phi` — golden-ratio spiral bars
- `northern_lights` — aurora-style gradient wash
- `winamp_line_style_spectrum` — classic Winamp line spectrum
- `bar_spectrum` / `spectrogram` — plain bar and spectrogram renders

Color themes (`cava/themes/`) are decoupled from the shaders — `tricolor` and
`solarized_dark` can be swapped independently.

---

## 📦 Repository layout

<details>
<summary>Full tree of tracked paths</summary>

```
cava/            audio visualizer config, shaders, color themes
hypr/            Hyprland compositor (hyprland.lua -> hyprland.conf)
hypr.bak/        previous Hyprland config, kept as a reference
kitty/           terminal emulator
mako/            notification daemon
nvim/            Neovim (single init.lua)
starship.toml    shell prompt
swaylock/        lock screen
waybar/          status bar + custom scripts
wofi/            app launcher
fastfetch/       system info banner (Tokyo Night theme)
neofetch/        system info banner (animated variant)
vite-plus/       vite-plus env/shim config
obs-studio/      OBS scenes, profiles, RTMP service definitions
Thunar/ xfce4/   file manager keybinds, custom actions, xsettings
gtk-3.0/         GTK3 theme settings
mimeapps.list    default application associations
git/             global gitignore
go/              go telemetry opt-in state
```

</details>

Everything not listed above — `Code/`, `Code - OSS/`, `mozilla/`, `discord/`,
`pgadmin4/`, `Insomnia/`, plus assorted auth tokens and cookies — is excluded
via [`.gitignore`](.gitignore): either heavy app cache/session data that isn't
really "config," or credentials that have no business in version control.

---

## 🚀 Usage

This repo lives at `~/.config` itself — there's no install script yet, so
cloning it elsewhere and copying back the pieces you want is the expected
workflow:

```sh
git clone <this-repo> ~/.config
# or cherry-pick:
cp -R hypr kitty mako waybar wofi swaylock starship.toml ~/.config/
chmod +x ~/.config/hypr/xdg-portal-hyprland
chmod +x ~/.config/waybar/scripts/waybar-wttr.py
```

Review `.gitignore` before trusting a fresh checkout wholesale — some
directories above (`obs-studio/`, `go/`) contain machine-specific state that
was committed as-is rather than templated.

---

## ⌨️ Keybindings

The mod key (`SUPER`) is the **Windows / ⌘ key**.

| Keys                        | Action                               |
| ---------------------------- | ------------------------------------- |
| `SUPER` + `Q`                 | Open terminal (kitty)                 |
| `SUPER` + `SPACE`             | App launcher (wofi)                   |
| `SUPER` + `E`                 | File manager (Thunar)                 |
| `SUPER` + `C`                 | Open VS Code                          |
| `SUPER` + `SHIFT` + `X`       | Close active window                   |
| `SUPER` + `V`                 | Toggle floating                       |
| `SUPER` + `F`                 | Toggle fullscreen                     |
| `SUPER` + `P`                 | Pseudotile (dwindle)                  |
| `SUPER` + `J`                 | Toggle split (dwindle)                |
| `SUPER` + `S`                 | Screenshot region → edit (grim/slurp/swappy) |
| `SUPER` + `L`                 | Lock screen                           |
| `SUPER` + `M`                 | Logout menu (wlogout)                 |
| `SUPER` + `SHIFT` + `M`       | Exit Hyprland                         |
| `SUPER` + `←↑↓→`              | Move focus                            |
| `SUPER` + `1`–`0`             | Switch to workspace                   |
| `SUPER` + `SHIFT` + `1`–`0`   | Move window to workspace              |
| `SUPER` + scroll              | Cycle workspaces                      |
| `SUPER` + drag                | Move (left) / resize (right) window   |
| `F3` / `F4` / `F5`            | Mute / volume down / volume up        |
| `F6` / `F7`                   | Brightness down / up                  |

A commented-out block in [`hypr/hyprland.lua`](hypr/hyprland.lua) has extra
binds for an ASUS ROG G15 Strix (Armory Crate key, fan profile switch, RGB
keyboard controls) — uncomment on that hardware, leave them off elsewhere.

---

## 🎨 Customizing

**Wallpaper** — set by `swaybg` in the autostart block of
[`hypr/hyprland.lua`](hypr/hyprland.lua):

```lua
hl.exec_cmd("swaybg -m fill -i " .. home .. "/.config/hypr/gargantuaRed.png")
```

Point it at any image and reload Hyprland, or apply it live without logging out:

```sh
pkill swaybg; swaybg -m fill -i ~/.config/hypr/your-wallpaper.jpg &
```

**Monitors** — edit the `hl.monitor({...})` block near the top of
`hyprland.lua`. The default (`preferred` / `auto` / scale `1.25`)
auto-detects; a dual-monitor example for a G15 Strix is included, commented out.

**cava visuals** — swap the active shader and color theme independently in
[`cava/config`](cava/config).
