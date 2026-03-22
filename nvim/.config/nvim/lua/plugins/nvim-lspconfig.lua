-- ================================================================================================
-- TITLE : nvim-lspconfig
-- ABOUT : Quickstart configurations for the built-in Neovim LSP client.
-- LINKS :
--   > github                  : https://github.com/neovim/nvim-lspconfig
--   > mason.nvim (dep)        : https://github.com/mason-org/mason.nvim
--   > blink.cmp (dep)         : https://github.com/saghen/blink.cmp
-- ================================================================================================

return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    -- LSP/DAP/Linter installer & manager
    {
      'mason-org/mason.nvim',
      opts = {
        PATH = 'prepend',
        ui = {
          icons = {
            package_pending = ' ',
            package_installed = ' ',
            package_uninstalled = ' ',
          },
        },
        max_concurrent_installers = 10,
      },
      config = function(_, opts)
        require('mason').setup(opts)
      end,
    },
    {
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      opts = {
        ensure_installed = {
          'lua-language-server',
          'pyright',
          'typescript-language-server',
          'tailwindcss-language-server',
          'clangd',
          'bash-language-server',
          'rust-analyzer',
          'html-lsp',
          'css-lsp',
          'gopls',
          'astro-language-server',
        },
        auto_update = false,
        run_on_start = true,
        start_delay = 3000,
        debounce_hours = 24,
      },
      config = function(_, opts)
        require('mason-tool-installer').setup(opts)
      end,
    },
    'saghen/blink.cmp', -- Allows extra capabilities provided by blink.cmp
  },
  config = function()
    require('utils.diagnostics').setup()
    require 'servers'
  end,
}
