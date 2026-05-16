return {
  'nvim-treesitter/nvim-treesitter',
  build = ":TSUpdate",
  lazy = false,
  config = function()
    require('nvim-treesitter.config').setup { }
    require('nvim-treesitter').install { "c", "lua", "rust", "python", "terraform", "cue", "typescript", "scss", "svelte", "javascript", "html", "jsx" }
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { "c", "lua", "rust", "python", "terraform", "cue", "typescript", "scss", "svelte", "javascript", "html", "jsx" },
      callback = function()
        vim.treesitter.start()
        vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.wo[0][0].foldmethod = 'expr'
      end,
    })
  end,
}
