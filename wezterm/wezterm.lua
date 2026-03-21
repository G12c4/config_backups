-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 14

config.enable_tab_bar = false

config.window_decorations = "RESIZE"
config.native_macos_fullscreen_mode = true
config.window_close_confirmation = "NeverPrompt"
config.skip_close_confirmation_for_processes_named = {}

-- TRANSPARENCY
config.window_background_opacity = 0.75
config.macos_window_background_blur = 50

-- Warm sunset dark theme with orange-red background
config.colors = {
    foreground = "#f2e9e1",
    background = "#1a110e",
    cursor_bg = "#ea9d34",
    cursor_border = "#ea9d34",
    cursor_fg = "#1a110e",
    selection_bg = "#2d1f1a",
    selection_fg = "#f2e9e1",

    -- ANSI colors (warm, natural spectrum)
    ansi = {
        "#1a110e",  -- black -> dark orange-red
        "#b4637a",  -- red -> rose
        "#d7827e",  -- green -> peach/coral
        "#ea9d34",  -- yellow -> gold
        "#286983",  -- blue -> teal
        "#907aa9",  -- magenta -> lavender
        "#56949f",  -- cyan -> sea blue
        "#c5c5c5",  -- white -> light gray
    },
    brights = {
        "#3d2a22",  -- bright black -> warm brown
        "#b4637a",  -- bright red
        "#d7827e",  -- bright green
        "#ea9d34",  -- bright yellow
        "#56949f",  -- bright blue
        "#907aa9",  -- bright magenta
        "#56949f",  -- bright cyan
        "#f2e9e1",  -- bright white -> cream
    },

    -- Tab bar colors
    tab_bar = {
        background = "#1a110e",
        active_tab = {
            bg_color = "#2d1f1a",
            fg_color = "#f2e9e1",
            intensity = "Bold",
        },
        inactive_tab = {
            bg_color = "#1a110e",
            fg_color = "#6a5a52",
        },
        inactive_tab_hover = {
            bg_color = "#2d1f1a",
            fg_color = "#f2e9e1",
        },
        new_tab = {
            bg_color = "#1a110e",
            fg_color = "#6a5a52",
        },
        new_tab_hover = {
            bg_color = "#2d1f1a",
            fg_color = "#ea9d34",
        },
    },
}

-- Key bindings
config.keys = {
    {
        key = "'",
        mods = "CTRL",
        action = wezterm.action.InputSelector {
            title = "Keybindings",
            choices = {
                { label = "Ctrl+Shift+P  → Command palette", id = "palette" },
                { label = "Ctrl+Shift+C  → Copy", id = "copy" },
                { label = "Ctrl+Shift+V  → Paste", id = "paste" },
                { label = "Ctrl+Alt+Enter → Toggle fullscreen", id = "fullscreen" },
                { label = "Ctrl+Shift+%  → Split vertical", id = "split_v" },
                { label = 'Ctrl+Shift+"  → Split horizontal', id = "split_h" },
                { label = "Ctrl+Shift+Z  → Toggle pane zoom", id = "zoom" },
                { label = "Ctrl+Shift+R  → Reload config", id = "reload" },
                { label = "Ctrl+Shift+F  → Search", id = "search" },
                { label = "Ctrl+Shift+K  → Clear scrollback", id = "clear" },
            },
            fuzzy = true,
            action = wezterm.action_callback(function(window, pane, id, label)
                if not id then return end
                if id == "palette" then window:perform_action(wezterm.action.ShowLauncherArgs { flags = "FUZZY|LAUNCH_MENU_ITEMS|KEY_ASSIGNMENTS" }, pane)
                elseif id == "copy" then window:perform_action(wezterm.action.CopyTo("Clipboard"), pane)
                elseif id == "paste" then window:perform_action(wezterm.action.PasteFrom("Clipboard"), pane)
                elseif id == "fullscreen" then window:perform_action(wezterm.action.ToggleFullScreen, pane)
                elseif id == "split_h" then window:perform_action(wezterm.action.SplitVertical { domain = "CurrentPaneDomain" }, pane)
                elseif id == "split_v" then window:perform_action(wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" }, pane)
                elseif id == "zoom" then window:perform_action(wezterm.action.TogglePaneZoomState, pane)
                elseif id == "reload" then window:perform_action(wezterm.action.ReloadConfiguration, pane)
                elseif id == "search" then window:perform_action(wezterm.action.Search("CurrentSelectionOrEmptyString"), pane)
                elseif id == "clear" then window:perform_action(wezterm.action.ClearScrollback("ScrollbackAndViewport"), pane)
                end
            end),
        }
    },
    {
        key = "p",
        mods = "CTRL|SHIFT",
        action = wezterm.action.ShowLauncherArgs { flags = "FUZZY|LAUNCH_MENU_ITEMS|KEY_ASSIGNMENTS" },
    },
}

-- Set leader key to Ctrl+A (press Ctrl+A twice to send actual Ctrl+A)
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

-- and finally, return the configuration to wezterm
return config
