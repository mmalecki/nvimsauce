local cmd = vim.api.nvim_command
local autocmd = vim.api.nvim_create_autocmd
local win_set = vim.api.nvim_win_set_option
local keymap = vim.api.nvim_set_keymap
local keymap_opts = { noremap = true, silent = true }

-- Indentation
-- vim.o.shiftwidth = 2
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

keymap("n", "<F5>", ":call jobstart([expand('%:e') == 'scad' ? 'openscad' : 'cq-editor', expand('%h')])<CR>", keymap_opts)

-- Look
cmd("colorscheme NeoSolarized")
vim.o.number = true
vim.o.termguicolors = true

-- Set up plugins
vim.g.terraform_fmt_on_save = 1

require('packer').startup(function (use)
  use 'wbthomason/packer.nvim'

  use 'neovim/nvim-lspconfig'

  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
      local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
      ts_update()
    end,
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = { "c", "lua", "rust", "python", "terraform", "cue", "typescript", "scss", "svelte" },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true
        }
      }
    end,
  }

  use {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end
  }

  use 'tpope/vim-commentary'

  use {
    'nmac427/guess-indent.nvim',
    config = function() require('guess-indent').setup {} end,
  }

  use 'hashivim/vim-terraform'

  use {
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup {}
    end
  }

  use {
    "kylechui/nvim-surround",
    tag = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
      require("nvim-surround").setup {}
    end
  }
end)

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
  end
})

-- Set up language servers
require'lspconfig'.terraformls.setup{}

require('lspconfig').tsserver.setup{}

require'lspconfig'.openscad_lsp.setup{
  cmd = { "openscad-lsp", "--stdio", "--fmt-style", "file", "--fmt-exe", "clang-format-15" }
}

require'lspconfig'.gopls.setup{}

require'lspconfig'.pyright.setup{}

require'lspconfig'.rust_analyzer.setup{}

-- Autocommands
autocmd('BufWritePre', {
  pattern = {'*'},
  callback = function()
    vim.lsp.buf.format()
  end
})
