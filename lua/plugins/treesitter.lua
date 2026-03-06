return {
  'nvim-treesitter/nvim-treesitter',
  build = ":TSUpdate",
  config = function()
    require('nvim-treesitter.config').setup {
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
