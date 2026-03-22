-- ================================================================================================
-- TITLE : lualine.nvim
-- LINKS :
--   > github : https://github.com/nvim-lualine/lualine.nvim
-- ABOUT : A blazing fast and easy to configure Neovim statusline written in Lua.
-- ================================================================================================
return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  config = function()
    local colors = {
      fg = '#f2e9e1',
      bg = '#1a110e',
      bg_alt = '#2d1f1a',
      bg_soft = '#3d2a22',
      accent = '#ea9d34',
      red = '#b4637a',
      green = '#d7827e',
      blue = '#286983',
      cyan = '#56949f',
      magenta = '#907aa9',
      muted = '#6a5a52',
    }

    local theme = {
      normal = {
        a = { fg = colors.bg, bg = colors.accent, gui = 'bold' },
        b = { fg = colors.fg, bg = colors.bg_alt },
        c = { fg = colors.fg, bg = colors.bg_alt },
        x = { fg = colors.fg, bg = colors.bg_alt },
        y = { fg = colors.fg, bg = colors.bg_alt },
        z = { fg = colors.bg, bg = colors.cyan, gui = 'bold' },
      },
      insert = {
        a = { fg = colors.bg, bg = colors.green, gui = 'bold' },
        b = { fg = colors.fg, bg = colors.bg_alt },
        c = { fg = colors.fg, bg = colors.bg_alt },
      },
      visual = {
        a = { fg = colors.bg, bg = colors.magenta, gui = 'bold' },
        b = { fg = colors.fg, bg = colors.bg_alt },
        c = { fg = colors.fg, bg = colors.bg_alt },
      },
      replace = {
        a = { fg = colors.bg, bg = colors.red, gui = 'bold' },
        b = { fg = colors.fg, bg = colors.bg_alt },
        c = { fg = colors.fg, bg = colors.bg_alt },
      },
      command = {
        a = { fg = colors.bg, bg = colors.blue, gui = 'bold' },
        b = { fg = colors.fg, bg = colors.bg_alt },
        c = { fg = colors.fg, bg = colors.bg_alt },
      },
      inactive = {
        a = { fg = colors.muted, bg = colors.bg },
        b = { fg = colors.muted, bg = colors.bg },
        c = { fg = colors.muted, bg = colors.bg },
      },
      tabline = {
        a = { fg = colors.fg, bg = colors.bg_alt, gui = 'bold' },
        b = { fg = colors.muted, bg = colors.bg },
        c = { fg = colors.fg, bg = colors.bg },
        x = { fg = colors.fg, bg = colors.bg },
        y = { fg = colors.fg, bg = colors.bg_alt },
        z = { fg = colors.bg, bg = colors.accent, gui = 'bold' },
      },
    }

    local hide_in_width = function()
      return vim.fn.winwidth(0) > 100
    end

    local mode = {
      'mode',
      fmt = function(str)
        if hide_in_width() then
          return ' ' .. str
        else
          return ' ' .. str:sub(1, 1) -- displays only the first character of the mode
        end
      end,
    }

    local filename = {
      'filename',
      file_status = true, -- displays file status (readonly status, modified status)
      path = 0, -- 0 = just filename, 1 = relative path, 2 = absolute path
    }

    local diagnostics = {
      'diagnostics',
      sources = { 'nvim_diagnostic' },
      sections = { 'error', 'warn' },
      symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
      colored = false,
      update_in_insert = false,
      always_visible = false,
      cond = hide_in_width,
    }

    local diff = {
      'diff',
      colored = false,
      symbols = { added = ' ', modified = ' ', removed = ' ' }, -- changes diff symbols
      cond = hide_in_width,
    }

    require('lualine').setup {
      options = {
        icons_enabled = true,
        theme = theme,
        -- Some useful glyphs:
        -- https://www.nerdfonts.com/cheat-sheet
        --        
        section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' },
        disabled_filetypes = { 'snacks_dashboard' },
        always_divide_middle = true,
      },
      sections = {
        lualine_a = { mode },
        lualine_b = { 'branch' },
        lualine_c = { filename },
        lualine_x = {
          Snacks.profiler.status(),
          {
            require('lazy.status').updates,
            cond = require('lazy.status').has_updates,
            color = function()
              return { fg = Snacks.util.color 'Special' }
            end,
          },
          diagnostics,
          diff,
          { 'filetype', cond = hide_in_width },
          { 'encoding', cond = hide_in_width },
        },
        lualine_y = { 'location' },
        lualine_z = { 'progress' },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { 'filename', path = 1 } },
        lualine_x = { { 'location', padding = 0 } },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {
        lualine_a = { { 'buffers', show_filename_only = true } },
      },
      extensions = { 'fugitive' },
    }
  end,
}
