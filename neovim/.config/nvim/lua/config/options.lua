-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.fixeol = true  -- Keep default for code

-- Apply fixeol = false to all markdown files (new and existing)
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.md",
  callback = function() vim.opt_local.fixeol = false end,
})
