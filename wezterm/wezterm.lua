-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Store custom tab titles (must be before any functions that use it)
local custom_tab_titles = {}

-- This is where you actually apply your config choices

config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 14
config.max_fps = 120
config.animation_fps = 120
config.window_close_confirmation = "NeverPrompt"

config.enable_tab_bar = true
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.tab_and_split_indices_are_zero_based = true
config.show_new_tab_button_in_tab_bar = false
config.tab_max_width = 32



config.window_decorations = "NONE"

config.window_background_opacity = 1.0

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

local function do_new_tab(window, pane)
    window:perform_action(
        wezterm.action.PromptInputLine {
            description = "Enter tab name:",
            action = wezterm.action_callback(function(window, pane, line)
                local tab, _ = window:mux_window():spawn_tab({})
                if line and line ~= "" then
                    custom_tab_titles[tab:tab_id()] = line
                end
            end),
        },
        pane
    )
end

local function do_new_workspace(window, pane)
    window:perform_action(
        wezterm.action.PromptInputLine {
            description = "Enter new workspace name:",
            action = wezterm.action_callback(function(window, pane, line)
                if line and line ~= "" then
                    window:perform_action(
                        wezterm.action.SwitchToWorkspace { name = line },
                        pane
                    )
                end
            end),
        },
        pane
    )
end

local function do_rename_tab(window, pane)
    window:perform_action(
        wezterm.action.PromptInputLine {
            description = "Enter new tab name:",
            action = wezterm.action_callback(function(window, pane, line)
                local tab = window:active_tab()
                if line and line ~= "" then
                    custom_tab_titles[tab:tab_id()] = line
                else
                    custom_tab_titles[tab:tab_id()] = nil
                end
            end),
        },
        pane
    )
end

local function do_rename_workspace(window, pane)
    window:perform_action(
        wezterm.action.PromptInputLine {
            description = "Enter new workspace name:",
            action = wezterm.action_callback(function(window, pane, line)
                if line and line ~= "" then
                    wezterm.mux.rename_workspace(window:active_workspace(), line)
                end
            end),
        },
        pane
    )
end

local function do_close_workspace(window, pane)
    local current_workspace = window:active_workspace()
    local workspaces = wezterm.mux.get_workspace_names()
    
    if #workspaces <= 1 then return end
    
    local target = nil
    for _, name in ipairs(workspaces) do
        if name ~= current_workspace then
            target = name
            break
        end
    end
    
    window:perform_action(wezterm.action.SwitchToWorkspace{name=target}, pane)
    
    for _, w in ipairs(wezterm.mux.all_windows()) do
        if w:get_workspace() == current_workspace then
            for _, t in ipairs(w:tabs()) do
                for _, p in ipairs(t:panes()) do
                    wezterm.background_child_process {
                        "wezterm", "cli", "kill-pane", "--pane-id", tostring(p:pane_id())
                    }
                end
            end
        end
    end
end

-- Key bindings
config.keys = {
    {
        key = "'",
        mods = "CTRL",
        action = wezterm.action.InputSelector {
            title = "Keybindings",
            choices = {
                { label = "Ctrl+Shift+P  → Command palette", id = "palette" },
                { label = "Ctrl+Shift+T  → New tab (named)", id = "new_tab" },
                { label = "Ctrl+A r      → Rename tab", id = "rename_tab" },
                { label = "Ctrl+A R      → Rename workspace", id = "rename_workspace" },
                { label = "Ctrl+Shift+X  → Close workspace", id = "close_workspace" },
                { label = "Ctrl+A s      → Switch workspace", id = "switch_workspace" },
                { label = "Ctrl+A S      → New workspace (prompt)", id = "new_workspace" },
                { label = "Ctrl+A w      → Close tab", id = "close_tab" },
                { label = "Ctrl+Shift+C  → Copy", id = "copy" },
                { label = "Ctrl+Shift+V  → Paste", id = "paste" },
                { label = "Ctrl+Tab      → Next tab", id = "next_tab" },
                { label = "Ctrl+Shift+Tab → Next workspace", id = "next_workspace" },
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
                if id == "palette" then window:perform_action(wezterm.action.ShowLauncherArgs { flags = "FUZZY|TABS|LAUNCH_MENU_ITEMS|KEY_ASSIGNMENTS" }, pane)
                elseif id == "new_tab" then do_new_tab(window, pane)
                elseif id == "rename_tab" then do_rename_tab(window, pane)
                elseif id == "rename_workspace" then do_rename_workspace(window, pane)
                elseif id == "close_workspace" then do_close_workspace(window, pane)
                elseif id == "switch_workspace" then window:perform_action(wezterm.action.ShowLauncherArgs { flags = "FUZZY|WORKSPACES" }, pane)
                elseif id == "new_workspace" then do_new_workspace(window, pane)
                elseif id == "close_tab" then window:perform_action(wezterm.action.CloseCurrentPane { confirm = false }, pane)
                elseif id == "copy" then window:perform_action(wezterm.action.CopyTo("Clipboard"), pane)
                elseif id == "paste" then window:perform_action(wezterm.action.PasteFrom("Clipboard"), pane)
                elseif id == "next_tab" then window:perform_action(wezterm.action.ActivateTabRelative(1), pane)
                elseif id == "next_workspace" then window:perform_action(wezterm.action.SwitchWorkspaceRelative(1), pane)
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
        action = wezterm.action.ShowLauncherArgs { flags = "FUZZY|TABS|LAUNCH_MENU_ITEMS|KEY_ASSIGNMENTS" },
    },
    {
        key = "t",
        mods = "CTRL|SHIFT",
        action = wezterm.action_callback(function(window, pane) do_new_tab(window, pane) end),
    },
    {
        key = "s",
        mods = "LEADER",
        action = wezterm.action.ShowLauncherArgs {
            flags = "FUZZY|WORKSPACES"
        },
    },
    {
        key = "S",
        mods = "LEADER|SHIFT",
        action = wezterm.action_callback(function(window, pane) do_new_workspace(window, pane) end),
    },
    {
        key = "w",
        mods = "LEADER",
        action = wezterm.action.CloseCurrentPane { confirm = false },
    },
    {
        key = "Tab",
        mods = "CTRL|SHIFT",
        action = wezterm.action.SwitchWorkspaceRelative(1),
    },
    {
        key = "r",
        mods = "LEADER",
        action = wezterm.action_callback(function(window, pane) do_rename_tab(window, pane) end),
    },
    {
        key = "R",
        mods = "LEADER|SHIFT",
        action = wezterm.action_callback(function(window, pane) do_rename_workspace(window, pane) end),
    },
    {
        key = "X",
        mods = "CTRL|SHIFT",
        action = wezterm.action_callback(function(window, pane) do_close_workspace(window, pane) end),
    },
}

-- Set leader key to Ctrl+A (press Ctrl+A twice to send actual Ctrl+A)
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

-- Nicer tab title with icons
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
    local title = custom_tab_titles[tab.tab_id] or tab.active_pane.title
    if title == "bash" or title == "zsh" or title == "fish" then
        title = "terminal"
    end

    local tab_idx = tab.tab_index + 1
    local icon = " "
    -- Add process-specific icons
    local process = tab.active_pane.foreground_process_name
    if process:match("nvim") or process:match("vim") then
        icon = " "
    elseif process:match("git") then
        icon = " "
    elseif process:match("ssh") then
        icon = " "
    end

    -- Truncate title if too long
    if #title > 20 then
        title = title:sub(1, 17) .. "..."
    end

    if tab.is_active then
        return {
            { Background = { Color = "#2d1f1a" } },
            { Foreground = { Color = "#ea9d34" } },
            { Text = icon .. tab_idx .. ": " .. title .. " " },
        }
    elseif hover then
        return {
            { Background = { Color = "#2d1f1a" } },
            { Foreground = { Color = "#d7827e" } },
            { Text = icon .. tab_idx .. ": " .. title .. " " },
        }
    else
        return {
            { Background = { Color = "#1a110e" } },
            { Foreground = { Color = "#6a5a52" } },
            { Text = icon .. tab_idx .. ": " .. title .. " " },
        }
    end
end)

-- Workspace tabs on the right side of tab bar
wezterm.on("update-right-status", function(window, pane)
    local workspaces = wezterm.mux.get_workspace_names()
    local current = window:active_workspace()

    local elements = {}

    for _, name in ipairs(workspaces) do
        if name == current then
            table.insert(elements, { Background = { Color = "#2d1f1a" } })
            table.insert(elements, { Foreground = { Color = "#ea9d34" } })
            table.insert(elements, { Text = " " .. name .. " " })
        else
            table.insert(elements, { Background = { Color = "#3d2a22" } })
            table.insert(elements, { Foreground = { Color = "#c5c5c5" } })
            table.insert(elements, { Text = " " .. name .. " " })
        end
    end

    table.insert(elements, { Background = { Color = "#1a110e" } })
    table.insert(elements, { Foreground = { Color = "#6a5a52" } })
    table.insert(elements, { Text = "  Ctrl+' " })

    window:set_right_status(wezterm.format(elements))
end)

-- and finally, return the configuration to wezterm
return config

