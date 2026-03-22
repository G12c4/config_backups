-- ================================================================================================
-- TITLE : Theme Loader
-- ABOUT : Loads theme based on desktop session (COSMIC or bspwm)
-- ================================================================================================

local M = {}

M.bspwm_dir = os.getenv("HOME") .. "/.config/bspwm"
M.rice_file = M.bspwm_dir .. "/.rice"
M.default_theme = "kanagawa-wave"
M.cosmic_theme = "kanagawa-wave"
M.palette = {
  fg = "#f2e9e1",
  bg = "#1a110e",
  bg_alt = "#2d1f1a",
  bg_soft = "#3d2a22",
  accent = "#ea9d34",
  red = "#b4637a",
  green = "#d7827e",
  blue = "#286983",
  cyan = "#56949f",
  magenta = "#907aa9",
  muted = "#6a5a52",
}
M.transparent = true

function M.apply_wezterm_palette()
  local p = M.palette
  local bg = M.transparent and "NONE" or p.bg
  local bg_alt = M.transparent and "NONE" or p.bg_alt

  local highlights = {
    Normal = { fg = p.fg, bg = bg },
    NormalNC = { fg = p.fg, bg = bg },
    NormalFloat = { fg = p.fg, bg = bg_alt },
    FloatBorder = { fg = p.accent, bg = bg_alt },
    EndOfBuffer = { fg = p.bg_soft, bg = bg },
    SignColumn = { bg = bg },
    LineNr = { fg = p.muted, bg = bg },
    CursorLine = { bg = bg_alt },
    CursorLineNr = { fg = p.accent, bold = true },
    Visual = { bg = p.bg_alt },
    Search = { fg = p.bg, bg = p.accent },
    IncSearch = { fg = p.bg, bg = p.green },
    Pmenu = { fg = p.fg, bg = bg_alt },
    PmenuSel = { fg = p.bg, bg = p.accent, bold = true },
    SnacksPickerListCursorLine = { fg = p.fg, bg = p.bg_soft, bold = true },
    SnacksPickerCursorLine = { fg = p.fg, bg = p.bg_soft, bold = true },
    SnacksPickerMatch = { fg = p.accent, bold = true },
    SnacksPickerSelected = { fg = p.accent, bold = true },
    SnacksPickerUnselected = { fg = p.muted },
    StatusLine = { fg = p.fg, bg = p.bg },
    StatusLineNC = { fg = p.muted, bg = p.bg },
    TabLine = { fg = p.muted, bg = p.bg },
    TabLineFill = { fg = p.muted, bg = p.bg },
    TabLineSel = { fg = p.fg, bg = p.bg_alt, bold = true },
    VertSplit = { fg = p.bg_soft, bg = bg },
    WinSeparator = { fg = p.bg_soft, bg = bg },
    Comment = { fg = p.muted, italic = true },
    Keyword = { fg = p.red, bold = true },
    Function = { fg = p.accent },
    Identifier = { fg = p.cyan },
    Type = { fg = p.blue },
    String = { fg = p.green },
    Constant = { fg = p.magenta },
  }

  for group, opts in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, opts)
  end
end

function M.set_colorscheme(theme, rice_name)
  vim.g.colors_name = theme
  vim.cmd("colorscheme " .. theme)
  M.apply_wezterm_palette()
  -- Match kitty terminal background color only for MoonKnight theme
  if rice_name == "MoonKnight" then
    vim.cmd("highlight Normal guibg=#212529")
  end
end

function M.load_theme_from_bspwm()
  local rice = nil
  local file = io.open(M.rice_file, "r")
  if file then
    rice = file:read("*a"):gsub("%s+", "")
    file:close()

    if rice and rice ~= "" then
      local theme_config = M.bspwm_dir .. "/rices/" .. rice .. "/theme-config.bash"
      local config = io.open(theme_config, "r")
      if config then
        local content = config:read("*a")
        config:close()

        for line in content:gmatch("[^\r\n]+") do
          local theme = line:match("^NVIM_THEME=\"([^\"]+)\"")
          if theme then
            M.set_colorscheme(theme, rice)
            return
          end
        end
      end
      -- Couldn't find NVIM_THEME in config, use default but pass rice for background override
      M.set_colorscheme(M.default_theme, rice)
      return
    end
  end
  -- No rice file or empty rice, use default without background override
  M.set_colorscheme(M.default_theme, nil)
end

function M.load_theme()
  local desktop = os.getenv("XDG_CURRENT_DESKTOP")
  if desktop == "COSMIC" then
    M.set_colorscheme(M.cosmic_theme, nil)
  else
    M.load_theme_from_bspwm()
  end
end

return M
