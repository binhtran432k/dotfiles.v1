return require('user.plugins.lsp_handler.lua-dev_handler').get_setup()
-- return {
--   settings = {
--     Lua = {
--       diagnostics = {
--         globals = { 'vim' },
--       },
--       workspace = {
--         library = {
--           [vim.fn.expand('$VIMRUNTIME/lua')] = true,
--           [vim.fn.stdpath('config') .. '/lua'] = true,
--         },
--       },
--     },
--   },
-- }
