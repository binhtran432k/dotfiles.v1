-- cSpell:ignore iamcco
local mappings = require('user.mappings')
local which_key = require('user.plugins.which-key_handler')
local configs = require('user.configs')

local M = {}

M.repo = 'iamcco/markdown-preview.nvim'
M.name = 'markdown-preview.nvim'
M.is_init = false
M.plugin_fn = function(_) end
local plantuml_jar = os.getenv('PLANTUML_JAR')
local plantuml_picoweb_host = 'localhost'
local plantuml_picoweb_port = '0'
local plantuml_port = nil
local plantuml_job_id = nil

function M.init(use, plugin_fn)
  use({
    M.repo,
    -- run = 'cd app && npm install',
    run = function() vim.fn["mkdp#util#install"]() end,
    ft = 'markdown',
    event = 'BufRead',
    -- requires = {
    --   -- { 'preservim/vim-markdown', after = M.name },
    --   -- { '~/.config/nvim/testplugin/vim-markdown', after = M.name },
    -- },
    setup = plugin_fn('pre_setup'),
    config = plugin_fn('setup'),
  })

  M.plugin_fn = plugin_fn
  M.is_init = true

  return { filetype_setup = true }
end

function M.pre_setup()
  if not M.is_init then
    return
  end

  vim.g.mkdp_browser = 'brave-popup'
  vim.g.vim_markdown_no_default_key_mappings = 1
  vim.g.vim_markdown_folding_disabled = 1
  vim.g.mkdp_filetypes = { 'markdown' }
  vim.g.mkdp_auto_close = 0
end

function M.setup()
  if not M.is_init then
    return
  end

  vim.cmd([[
  command! MarkdownPreviewRunLocalPlanuml lua require('user.plugins.markdown-preview_handler').run_local_plantuml()
  command! MarkdownPreviewStopLocalPlanuml lua require('user.plugins.markdown-preview_handler').stop_local_plantuml()
  ]])
end

function M.register_filetype_setup()
  if not M.is_init then
    return
  end

  configs.register_filetype(
    'markdown',
    'preview',
    M.plugin_fn('filetype_setup')
  )
end

function M.filetype_setup()
  if not M.is_init then
    return
  end

  M._bind_buf_keys()
  M._bind_buf_which_keys()
end

function M._bind_buf_keys()
  local binds = {
    {
      key = '<localleader>ll',
      cmd = '<Cmd>MarkdownPreview<CR>',
      opt = { silent = true },
    },
    {
      key = '<localleader>lr',
      cmd = '<Cmd>MarkdownPreviewRunLocalPlanuml<CR>',
      opt = { silent = true },
    },
    {
      key = '<localleader>ls',
      cmd = '<Cmd>MarkdownPreviewStopLocalPlanuml<CR>',
      opt = { silent = true },
    },
  }

  mappings.bind_buf_keys(0, binds)
end

function M._bind_buf_which_keys()
  local which_keys = {
    {
      mapping = {
        ['<localleader>l'] = {
          name = 'Markdown Preview',
          l = 'Open Markdown Preview',
          r = 'Run Markdown Preview Local Planuml',
          s = 'Stop Markdown Preview Local Plantuml',
        },
      },
    },
  }

  which_key.bind_buf_which_keys(0, which_keys)
end

function M.reload_markdown_options()
  local server = plantuml_port
      and 'http://' .. plantuml_picoweb_host .. ':' .. plantuml_port
    or 'http://www.plantuml.com/plantuml'
  vim.g.mkdp_preview_options = {
    mkit = {},
    katex = {},
    uml = {
      server = server,
    },
    maid = {},
    disable_sync_scroll = 0,
    sync_scroll_type = 'middle',
    hide_yaml_meta = 1,
    sequence_diagrams = {},
    flowchart_diagrams = {},
    content_editable = false,
    disable_filename = 0,
  }
end

function M.run_local_plantuml()
  if plantuml_job_id then
    vim.notify('local plantuml already run with id ' .. plantuml_job_id)
    return
  end
  vim.fn.jobstart({
    'java',
    '-jar',
    plantuml_jar,
    '-picoweb:' .. plantuml_picoweb_port .. ':' .. plantuml_picoweb_host,
  }, {
    on_stdout = function(_, d)
      print(vim.inspect(d))
    end,
    on_exit = function()
      print('Stopped server with port ' .. plantuml_port)
      plantuml_job_id = nil
      plantuml_port = nil
      M.reload_markdown_options()
    end,
    on_stderr = function(j, d)
      plantuml_job_id = j
      if d[1]:match('^webPort=') then
        local port = tonumber(string.sub(d[1], 9))
        print('Started server with port ' .. port)
        plantuml_port = port
        M.reload_markdown_options()
      end
    end,
  })
end

function M.stop_local_plantuml()
  if plantuml_job_id then
    vim.fn.jobstop(plantuml_job_id)
  end
end

return M
