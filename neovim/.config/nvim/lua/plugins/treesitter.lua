return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "lua", "javascript", "python", "rust", 
        "html", "css", "json", "markdown",
        "bash", "vim", "regex", "typescript",
      },
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = { enable = true },
    })
  end
}
