return {
  'nvim-treesitter/nvim-treesitter',
  build = ":TSUpdate",
  lazy = false,
  config = function()
    require('nvim-treesitter.config').setup { }
    require('nvim-treesitter').install { "c", "lua", "rust", "python", "terraform", "cue", "typescript", "scss", "svelte", "javascript", "html", "jsx" }
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { '*' },
      callback = function() vim.treesitter.start() end,
    })
  end,
}
