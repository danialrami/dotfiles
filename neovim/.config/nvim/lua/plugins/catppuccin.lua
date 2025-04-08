return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha", -- Choose: latte, frappe, macchiato, mocha
      transparent_background = false,
      integrations = {
        telescope = true,
        mason = true,
        neotree = true,
      },
    })
    vim.cmd.colorscheme "catppuccin"
  end
}
