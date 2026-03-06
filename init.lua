local cmd = vim.api.nvim_command
local autocmd = vim.api.nvim_create_autocmd
local win_set = vim.api.nvim_win_set_option
local keymap = vim.api.nvim_set_keymap
local keymap_opts = { noremap = true, silent = true }

-- Indentation
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.tabstop = 2

-- Filename completion
vim.opt.wildignore:append{"*.pdf","*.stl","*.step","*.3mf","*.jpg","*.png"}

-- Search options
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keymappings
keymap("n", ";", ":", keymap_opts)
keymap("i", "kj", "<ESC>", keymap_opts)
keymap("t", "kj", "<C-\\><C-n>", keymap_opts)

keymap("n", "<F5>", ":call jobstart([expand('%:e') == 'scad' ? 'openscad' : 'ocp-view', expand('%h')])<CR>", keymap_opts)

-- Look
vim.o.number = true

-- Set up plugins
vim.g.terraform_fmt_on_save = 1

require("config.lazy")
-- Plugins left to migrate to Lazy:
--   use {
--     'nmac427/guess-indent.nvim',
--     config = function() require('guess-indent').setup {} end,
--   }

--   use 'hashivim/vim-terraform'

--   use 'tpope/vim-abolish'

--   use 'knsh14/vim-github-link'
-- end)

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    local bufopts = { noremap = true, silent = true, buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', 'cR', vim.lsp.buf.rename, bufopts)
  end
})

-- Set up language servers
vim.lsp.enable('terraformls')
vim.lsp.enable('ts_ls')
vim.lsp.enable('openscad_lsp', {
  cmd = { "openscad-lsp", "--stdio", "--fmt-style", "file", "--fmt-exe", "clang-format-15" }
})

vim.lsp.enable('pyright')
vim.lsp.enable('gopls')
vim.lsp.enable('rust_analyzer')
vim.lsp.enable('clangd')

vim.lsp.set_log_level("off")

-- Autocommands
autocmd('BufWritePre', {
  pattern = {'*.ts', '*.py', '*.rs'},
  callback = function()
    vim.lsp.buf.format({ async = true })
  end
})
