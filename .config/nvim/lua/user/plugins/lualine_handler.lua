-- local gps = require('user.plugins.gps')
local lsp_config = require('user.plugins.lsp_handler.lsp-config_handler')
local gitsigns = require('user.plugins.gitsigns_handler')
local dracula_handler = require('user.plugins.dracula_handler')
local dependencies_handler = require('user.plugins.dependencies_handler')

local M = {}

M.repo = 'nvim-lualine/lualine.nvim'
M.is_init = false

function M.init(use, plugin_fn)
  use({
    M.repo,
    event = 'BufRead',
    after = dracula_handler.name,
    requires = dependencies_handler.web_devicons,
    config = plugin_fn('setup'),
  })

  M.is_init = true and not _G.is_readonly_mode
end

function M.setup()
  if not M.is_init then
    return
  end

  --- @param trunc_width number trunctates component when screen width is less then trunc_width
  --- @param trunc_len number truncates component to trunc_len number of chars
  --- @param hide_width number hides component when window width is smaller then hide_width
  --- @param no_ellipsis boolean whether to disable adding '...' at end after truncation
  --- return function that can format the component accordingly
  local function trunc(trunc_width, trunc_len, hide_width, no_ellipsis)
    return function(str)
      local win_width = vim.fn.winwidth(0)
      if hide_width and win_width < hide_width then
        return ''
      elseif
        trunc_width
        and trunc_len
        and win_width < trunc_width
        and #str > trunc_len
      then
        return str:sub(1, trunc_len) .. (no_ellipsis and '' or '...')
      end
      return str
    end
  end

  local lualine = require('lualine')
  lualine.setup({
    options = {
      icons_enabled = true,
      theme = 'auto',
      -- component_separators = { left = '│', right = '│' },
      -- section_separators = { left = '▒', right = '▒' },
      -- section_separators = { left = '', right = '' },
      disabled_filetypes = { 'alpha' },
      always_divide_middle = true,
    },
    sections = {
      lualine_a = { { 'mode', fmt = trunc(100, 4, nil, true) } },
      lualine_b = {
        gitsigns.get_lualine_branch(trunc(nil, nil, 60)),
        gitsigns.get_lualine_diff(trunc(nil, nil, 120)),
        {
          'diagnostics',
          fmt = trunc(nil, nil, 60),
          symbols = {
            hint = ' ',
            info = ' ',
            warn = ' ',
            error = ' ',
          },
        },
      },
      lualine_c = {
        { 'filename', fmt = trunc(60, 20, nil, true) },
        -- gps.get_lualine(trunc(nil, nil, 120)),
      },
      lualine_x = {
        lsp_config.get_lualine(trunc(nil, nil, 120)),
        { 'encoding', fmt = trunc(nil, nil, 80) },
        { 'fileformat', fmt = trunc(nil, nil, 80) },
        { 'filetype', fmt = trunc(90, 30, 50), icons_enabled = false },
      },
      lualine_y = {},
      lualine_z = { M.get_custom_location() },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { 'filename' },
      lualine_x = { M.get_custom_location() },
      lualine_y = {},
      lualine_z = {},
    },
    extensions = { 'fugitive', 'nvim-tree', 'toggleterm' },
  })
end

function M.get_custom_location()
  return [[%p%% %{''}%l/%L :%v]]
end

return M
