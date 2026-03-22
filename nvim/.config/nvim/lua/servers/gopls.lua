-- ================================================================================================
-- TITLE : gopls (Go Language Server) LSP Setup
-- LINKS :
--   > github: https://github.com/golang/tools/tree/master/gopls
-- ================================================================================================

--- @param capabilities table LSP client capabilities (typically from blink-cmp or similar)
--- @return nil
return function(capabilities)
  vim.lsp.config('gopls', {
    capabilities = capabilities,
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
        gofumpt = true,
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
      },
    },
  })
end
