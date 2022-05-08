-- Setup augroup to make this config reloadable at runtime
local init_lua_augroup = vim.api.nvim_create_augroup('init.lua', {})
local function addAutocommand(event, pattern, vim_command_or_lua_callback)
  local args = { pattern = pattern, group = init_lua_augroup }
  if type(vim_command_or_lua_callback) == 'string' then
    args.command = vim_command_or_lua_callback
  else
    args.callback = vim_command_or_lua_callback
  end
  vim.api.nvim_create_autocmd(event, args)
end

-- Reload this config when it's saved to disk
local init_lua_path = vim.fn.stdpath('config') .. '/init.lua'
addAutocommand('BufWritePost', init_lua_path, function() dofile(init_lua_path) end)

-- Some helper functions
local function addFiletypeAutocommand(filetype_name, vim_command_or_lua_callback)
  addAutocommand('FileType', filetype_name, vim_command_or_lua_callback)
end

-- General settings
vim.opt.cursorline    = true
vim.opt.expandtab     = true
vim.opt.foldmethod    = 'syntax'
vim.opt.guicursor     = ''
vim.opt.ignorecase    = true
vim.opt.modeline      = false
vim.opt.mouse         = 'a'
vim.opt.number        = true
vim.opt.numberwidth   = 1
vim.opt.scrolloff     = 3
vim.opt.shada         = '!,\'10000,<50,s10,h'
vim.opt.shiftwidth    = 2
vim.opt.smartcase     = true
vim.opt.smartindent   = true
vim.opt.softtabstop   = -1
vim.opt.spelllang     = 'en,de'
vim.opt.startofline   = true
vim.opt.termguicolors = true
vim.opt.textwidth     = 100
vim.opt.wrap          = false
vim.opt.writebackup   = false
vim.g.mapleader       = ','

-- Force auto-wrapping long lines while typing
addAutocommand('BufEnter', '*', function() vim.bo.formatoptions = vim.bo.formatoptions .. 't' end)

-- Prevent text from being (un)folded while typing
addAutocommand('InsertEnter', '*', function()
  vim.w.last_foldmethod = vim.wo.foldmethod
  vim.wo.foldmethod = 'manual'
end)
addAutocommand('InsertLeave', '*', function()
  if vim.w.last_foldmethod ~= nil then
    vim.wo.foldmethod = vim.w.last_foldmethod
    vim.w.last_foldmethod = nil
  end
end)

-- Setup folds when opening files
addAutocommand('BufWinEnter', '*', 'normal! zR')

-- Force QuickFix window to the far bottom
addFiletypeAutocommand('qf', function()
  if vim.bo.buftype == 'quickfix' and vim.fn.getwininfo(vim.fn.win_getid())[1].loclist ~= 1 then
    vim.api.nvim_command('wincmd J')
  end
end)

-- Keep location list populated with diagnostics
addAutocommand('DiagnosticChanged', '*', function() vim.diagnostic.setloclist{ open = false } end)

-- Regenerate helptags
vim.api.nvim_command('helptags ALL')

-- General mappings
vim.keymap.set('',  'j',         'gj')
vim.keymap.set('',  'k',         'gk')
vim.keymap.set('n', 'Y',         'y$')
vim.keymap.set('n', 'p',         ']p')
vim.keymap.set('n', 'P',         ']P')
vim.keymap.set('n', 'S',         ':w<cr>')
vim.keymap.set('n', 'zV',        'zMzv')
vim.keymap.set('n', 'Q',         'mqgqip`q')
vim.keymap.set('n', '<a-q>',     'mqgqi{`q')
vim.keymap.set('n', '<leader>s', '1z=')
vim.keymap.set('n', '<a-n>',     '@=\'n.\'<cr>')
vim.keymap.set('n', '<leader>ce', function()
  vim.fn.setreg('/', '\\<' .. vim.fn.expand('<cword>') .. '\\>')
  vim.api.nvim_input('ciw')
end)
vim.keymap.set('c', '<c-k>', '<Up>')
vim.keymap.set('c', '<c-j>', '<Down>')

-- Mappings for window navigation
vim.keymap.set('n', '<a-h>', '<c-w><c-h>')
vim.keymap.set('n', '<a-j>', '<c-w><c-j>')
vim.keymap.set('n', '<a-k>', '<c-w><c-k>')
vim.keymap.set('n', '<a-l>', '<c-w><c-l>')
vim.keymap.set('t', '<a-h>', '<c-\\><c-n><c-w><c-h>')
vim.keymap.set('t', '<a-j>', '<c-\\><c-n><c-w><c-j>')
vim.keymap.set('t', '<a-k>', '<c-\\><c-n><c-w><c-k>')
vim.keymap.set('t', '<a-l>', '<c-\\><c-n><c-w><c-l>')
vim.keymap.set('t', '<c-w>H', '<c-\\><c-n><c-w>H')
vim.keymap.set('t', '<c-w>J', '<c-\\><c-n><c-w>J')
vim.keymap.set('t', '<c-w>K', '<c-\\><c-n><c-w>K')
vim.keymap.set('t', '<c-w>L', '<c-\\><c-n><c-w>L')
vim.keymap.set('t', '<c-w>=', '<c-\\><c-n><c-w>=i')
vim.keymap.set('t', '<c-w>_', '<c-\\><c-n><c-w>_i')
vim.keymap.set('t', '<c-w>v', '<c-\\><c-n><c-w>v')
vim.keymap.set('t', '<c-w>s', '<c-\\><c-n><c-w>s')

-- Mappings for searching
vim.keymap.set('', '/', '/\\v')
vim.keymap.set('', '?', '?\\v')
vim.keymap.set('', '#', function()
  vim.fn.setreg('/', '\\<' .. vim.fn.expand('<cword>') .. '\\>')
  vim.api.nvim_input('N')
end)
vim.keymap.set('', '<c-n>', 'nzzzO')
vim.keymap.set('n', '<Esc><Esc>', function() vim.api.nvim_command('nohlsearch') end)

local function runGrepWithCurrentSearchString(dir_to_search)
  local search_string = string.gsub(vim.fn.getreg('/'), '^\\v', '')
  search_string = string.gsub(search_string, '|', '\\|')
  local grep_case_sensitive_flag = string.match(search_string, '%u') and '' or '-i'
  vim.api.nvim_command('silent! grep! -riE ' .. grep_case_sensitive_flag
  .. ' --exclude-dir=.git/ --exclude-dir=build/ -- ' .. vim.fn.shellescape(search_string)
  .. ' ' .. vim.fn.shellescape(dir_to_search))
  vim.api.nvim_command('copen')
end
vim.keymap.set('n', '<leader>gg', function() runGrepWithCurrentSearchString('.') end)

-- Language specific settings
-- Bash and sh
vim.g.sh_fold_enabled = 1

-- C and C++
vim.g.c_syntax_for_h = 1
vim.opt.cinoptions = '(0,E-s,N-s,U0,c0,g0,h0,i0,js,w1'
addAutocommand({ 'BufNewFile', 'BufRead' }, { '*.[ch]', '*.[ch]pp' }, function()
  vim.wo.spell = true
end)
addFiletypeAutocommand({ 'c', 'cpp' }, function()
  vim.bo.textwidth = 0
  vim.bo.formatexpr = 'v:lua.vim.lsp.formatexpr()'
  vim.keymap.set('', '=', 'gq', { buffer = 0 })
end)

-- Config
addFiletypeAutocommand('config', function() vim.bo.textwidth = 0 end)

-- Git
addFiletypeAutocommand('git', function()
  vim.wo.spell = false
  vim.wo.wrap = true
end)
addFiletypeAutocommand('gitcommit', function()
  vim.wo.spell = true
  vim.bo.textwidth = 72
end)
addFiletypeAutocommand('GV', function() vim.wo.spell = false end)

-- Help
addFiletypeAutocommand('help', function() vim.bo.textwidth = 78 end)

-- Html
addFiletypeAutocommand('html', function() vim.bo.textwidth = 0 end)

-- Markdown
vim.g.markdown_fenced_languages = {
  'c', 'cpp', 'lisp', 'clojure', 'sh', 'bash=sh', 'css',
  'javascript', 'js=javascript', 'json=javascript', 'perl', 'php',
  'python', 'ruby', 'html', 'vim', 'desktop', 'diff',
}
addFiletypeAutocommand('markdown', function() vim.wo.spell = true end)

-- Python
addFiletypeAutocommand('python', function()
  vim.wo.wrap = true
  vim.bo.textwidth = 0
end)

-- Qf (QuickFix)
addFiletypeAutocommand('qf', function() vim.wo.spell = false end)

-- Scheme
vim.g.is_chicken = 1
addFiletypeAutocommand('qf', function() vim.wo.foldnestmax = 2 end)

-- Tex
vim.g.tex_flavor = 'latex'
addAutocommand({ 'BufNewFile', 'BufRead' }, '*.lco', function() vim.bo.filetype = 'tex' end)
addFiletypeAutocommand('tex', function()
  vim.wo.spell = true
  vim.wo.foldmethod = 'marker'
end)

-- Typescript
addAutocommand({ 'BufNewFile', 'BufRead' }, '*.tsx', function() vim.bo.filetype = 'typescript' end)

-- Vim
vim.g.vim_indent_cont = vim.go.shiftwidth
addFiletypeAutocommand('vim', function() vim.wo.foldmethod = 'marker' end)

-- Mapping for discarding undo history
vim.keymap.set('n', '<leader>du', function()
  if not vim.bo.modifiable then
    return
  end

  local prev_undolevels = vim.bo.undolevels
  local prev_modified = vim.bo.modified
  vim.bo.undolevels = -1
  vim.api.nvim_command('execute "noautocmd normal! i \\<esc>\\"_x"')
  vim.bo.undolevels = prev_undolevels
  if prev_modified == false then
    vim.bo.modified = false
   end
end)

-- Setup terminal and preserve terminal mode when switching windows
addAutocommand('TermOpen', '*', function()
  vim.wo.number = false
  vim.wo.spell = false

  vim.api.nvim_create_autocmd({ 'BufWinEnter', 'WinEnter' }, {
    buffer = 0,
    group = init_lua_augroup,
    callback = function()
      if vim.b.restoreTerminalMode ~= nil then
        vim.api.nvim_command('startinsert')
      end
    end
  })
  vim.keymap.set('t', '<c-\\><c-n>', function()
    vim.api.nvim_command('stopinsert')
    vim.b.restoreTerminalMode = nil
  end, { buffer = 0 })

  for _, key in ipairs{ 'A', 'a', 'I', 'i' } do
    vim.keymap.set('n', key, function()
      vim.b.restoreTerminalMode = true
      vim.api.nvim_feedkeys(key, 'nt', false)
    end, { buffer = 0 })
  end

  local events = {
    'LeftMouse', 'LeftDrag', 'LeftRelease', 'MiddleMouse', 'MiddleDrag', 'MiddleRelease',
    'RightMouse', 'RightDrag', 'RightRelease', 'X1Mouse', 'X1Drag', 'X1Release', 'X2Mouse',
    'X2Drag', 'X2Release', 'ScrollWheelUp', 'ScrollWheelDown',
  }
  for _, event in ipairs(events) do
    for _, modifier in ipairs{ "", "A-", "C-", "S-" } do
      local mapping = '<' .. modifier .. event .. '>'
      vim.keymap.set('t', mapping, function()
        vim.api.nvim_command('stopinsert')
        vim.b.restoreTerminalMode = nil
      end, { buffer = 0 })
    end
  end
  vim.b.restoreTerminalMode = true
  vim.api.nvim_command('startinsert!')
end)

-- Netrw
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_localrmdir = 'rm -rf'

-- Termdebug
vim.api.nvim_command('packadd termdebug')

vim.g.termdebug_wide = 1

local function startDebugSession(opts)
  vim.keymap.set('n', '<F5>', function() vim.api.nvim_exec('Step') end)
  vim.keymap.set('n', '<F6>', function() vim.api.nvim_exec('functiOver') end)
  vim.keymap.set('n', '<F7>', function() vim.api.nvim_exec('functiFinish') end)
  vim.keymap.set('n', '<F8>', function() vim.api.nvim_exec('Evaluate') end)
  vim.keymap.set('n', '<F8>', function() vim.api.nvim_exec('Evaluate') end)
  vim.api.nvim_command('TermdebugCommand ' .. opts.args)
end
vim.api.nvim_create_user_command('Debug', startDebugSession, { nargs = '+', complete = 'file' })

-- nvim-cmp
local nvim_cmp = require('cmp')
nvim_cmp.setup{
  mapping = nvim_cmp.mapping.preset.insert{
    ['<CR>'] = nvim_cmp.mapping.select_next_item(),
  },
  sources = nvim_cmp.config.sources{
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'nvim_lua' },
    { name = 'buffer' },
    { name = 'path' },
    { name = 'ultisnips' },
    { name = 'emoji', option = { insert = true } },
  },
}

-- lsp settings
local capabilities =
  require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
local on_attach = function(client, bufnr)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = 0 })
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = 0 })
  vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references, { buffer = 0 })
end
require('lspconfig').clangd.setup{ capabilities = capabilities, on_attach = on_attach }

local lsp_diagnostic_symbols = { error = ' ', warn = ' ', hint = ' ', info = ' ' }
for type, icon in pairs(lsp_diagnostic_symbols) do
  local hl = 'DiagnosticSign' .. type:gsub('^%l', string.upper)
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- null-ls.nvim
local null_ls = require('null-ls');
null_ls.setup{
  sources = {
    null_ls.builtins.diagnostics.shellcheck,
  }
}

-- telescope.nvim
require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        ["<c-j>"] = "move_selection_next",
        ["<c-k>"] = "move_selection_previous",
        ["<esc>"] = "close",
      }
    }
  }
}
vim.keymap.set('n', '<c-p>', function() require("telescope.builtin").find_files{ hidden=true } end)
vim.keymap.set('n', '<c-f>', require("telescope.builtin").oldfiles)
vim.keymap.set('n', '<c-h>', require("telescope.builtin").help_tags)

-- ultisnips
vim.g.UltiSnipsEditSplit = 'horizontal'
vim.g.UltiSnipsExpandTrigger = '<tab>'
vim.g.UltiSnipsJumpForwardTrigger = '<tab>'
vim.g.UltiSnipsJumpBackwardTrigger = '<s-tab>'
vim.keymap.set('n', '<leader>u', function() vim.api.nvim_command('UltiSnipsEdit') end)

addFiletypeAutocommand('snippets', function()
  vim.bo.expandtab = false
  vim.bo.tabstop = 2
  vim.bo.textwidth = 2
end)
addAutocommand('BufWritePost', '*.snippets', 'call UltiSnips#RefreshSnippets()')
addAutocommand('BufWinEnter', '*.snippets', 'normal! zM')

-- vim-fugitive
vim.keymap.set('n', '<a-s>', function() vim.api.nvim_command('Gwrite') end)
vim.keymap.set('n', '<F10>', function() vim.api.nvim_command('Git') end)
vim.keymap.set('n', '<F11>', function() vim.api.nvim_command('Git commit') end)
vim.keymap.set('n', '<F12>', function() vim.api.nvim_command('Git push') end)
addFiletypeAutocommand('fugitive', function() vim.wo.wrap = true end)
addFiletypeAutocommand('fugitiveblame', function() vim.wo.spell = false end)

-- gv.vim
vim.keymap.set('n', '<F9>', function() vim.api.nvim_command('GV --all') end)

-- vim-table-mode
vim.g.table_mode_corner = '|'
vim.g.table_mode_motion_up_map    = ''
vim.g.table_mode_motion_down_map  = ''
vim.g.table_mode_motion_left_map  = ''
vim.g.table_mode_motion_right_map = ''
addFiletypeAutocommand({ 'markdown', 'text' }, 'silent TableModeEnable')

-- vim-better-whitespace
vim.g.better_whitespace_filetypes_blacklist = { 'qf', 'diff', 'git' }
addFiletypeAutocommand('fugitive', 'DisableWhitespace')
vim.keymap.set('n', '<leader>tw', function() vim.api.nvim_command('ToggleWhitespace') end)

-- vim-easy-align
vim.keymap.set('v', '<cr>', '<Plug>(EasyAlign)*')

-- vimtex
vim.g.vimtex_quickfix_mode = 0

-- nightfox
if vim.g.colors_name == nil then
  vim.api.nvim_command('colorscheme nightfox')
end

vim.keymap.set('n', '<leader>cs', function()
  if vim.g.colors_name == 'nightfox' then
    vim.api.nvim_command('colorscheme dayfox')
  else
    vim.api.nvim_command('colorscheme nightfox')
  end
end)

-- build.vim
local function makeBuildCallback(build_args)
  return function()
    vim.api.nvim_command('wall')
    vim.api.nvim_call_function('build#target', build_args)
  end
end
vim.keymap.set('n', '<F1>', makeBuildCallback({'clean'}))
vim.keymap.set('n', '<F2>', makeBuildCallback({}))
vim.keymap.set('n', '<F3>', makeBuildCallback({'test'}))
vim.keymap.set('n', '<F4>', makeBuildCallback({'run'}))

local build_c_flags = '-Wall -Wextra -pedantic -O0 -coverage -ggdb -fsanitize=address,undefined'
vim.api.nvim_create_user_command('CMakeInit', function(opts)
  vim.api.nvim_call_function('build#target', {
    'init -DCMAKE_BUILD_TYPE=Debug -DCMAKE_C_FLAGS="' .. build_c_flags .. '"'
    .. ' -DCMAKE_CXX_FLAGS="' .. build_c_flags .. ' -Wno-missing-field-initializers"'
    .. ' ' .. opts.args
  })
end, { nargs = '?' })
vim.api.nvim_create_user_command('CMakeInitClang', function(opts)
  local extra_clang_flags = build_c_flags .. ' -Wdocumentation'
  vim.api.nvim_call_function('build#target', {
    'init -DCMAKE_BUILD_TYPE=Debug -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++'
    .. ' -DCMAKE_C_FLAGS="'   .. extra_clang_flags .. '"'
    .. ' -DCMAKE_CXX_FLAGS="' .. extra_clang_flags .. ' -stdlib=libstdc++"'
    .. ' ' .. opts.args
  })
end, { nargs = '?' })

-- lualine.nvim
local lualine_section_opts = {
  lualine_a = {{ 'mode', fmt = function(_) return '' end }},
  lualine_b = {{ 'branch', icon = '' }},
  lualine_c = {{ 'filename', path = 1, symbols = { modified = ' ', readonly = ' ' }}},
  lualine_x = {{ 'diagnostics', symbols = diagnostic_symbols }},
  lualine_y = {{ 'progress' }},
  lualine_z = {{ 'location'}},
}
require('lualine').setup{
  options = { section_separators = { left = '◣', right = '◢' }},
  sections = lualine_section_opts,
  inactive_sections = lualine_section_opts,
  extensions = { 'quickfix' },
}

-- Setup and load ./custom/ directory
local custom_dir_path = vim.fn.stdpath('config') .. '/custom'
vim.fn.mkdir(custom_dir_path .. '/spell', 'p')
vim.fn.mkdir(custom_dir_path .. '/UltiSnips', 'p')
vim.opt.spellfile = custom_dir_path .. '/spell/custom.utf-8.add'
vim.g.UltiSnipsSnippetStorageDirectoryForUltiSnipsEdit = custom_dir_path .. '/UltiSnips'

local custom_init_lua_path = custom_dir_path .. '/init.lua'
addAutocommand('BufWritePost', custom_init_lua_path, function() dofile(init_lua_path) end)
if vim.fn.filereadable(custom_init_lua_path) == 1 then
  dofile(custom_init_lua_path)
end