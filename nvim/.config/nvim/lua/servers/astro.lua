-- ================================================================================================
-- TITLE : astro (Astro Language Server) LSP Setup
-- LINKS :
--   > github: https://github.com/withastro/language-tools
-- ================================================================================================

--- @param capabilities table LSP client capabilities (typically from blink-cmp or similar)
--- @return nil
return function(capabilities)
  vim.lsp.config('astro', {
    cmd = { 'astro-ls', '--stdio' },
    capabilities = capabilities,
    filetypes = { 'astro' },
    init_options = {
      typescript = {},
    },
  })
end
