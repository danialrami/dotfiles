-- Load vim options
require("vim-options")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Initialize lazy.nvim
require("lazy").setup("plugins", {
  install = { colorscheme = { "habamax" } },
  checker = { enabled = true },
})

-- Telescope keymaps (wrapped in pcall for safety)
local telescope_ok, builtin = pcall(require, "telescope.builtin")
if telescope_ok then
  vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
  vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
end

-- Neotree keymap
vim.keymap.set('n', '<C-n>', ':Neotree toggle<CR>', {})

-- SuperCollider configuration
local scnvim_ok, scnvim = pcall(require, 'scnvim')
if scnvim_ok then
  local map = scnvim.map
  local map_expr = scnvim.map_expr

  scnvim.setup({
    keymaps = {
      ['<M-e>'] = map('editor.send_line', {'i', 'n'}),
      ['<C-e>'] = {
        map('editor.send_block', {'i', 'n'}),
        map('editor.send_selection', 'x'),
      },
      ['<M-o>'] = map('postwin.toggle'),
      ['<M-O>'] = map('postwin.toggle', 'i'),
      ['<C-l>'] = map('postwin.clear', {'n', 'i'}),
      ['<C-k>'] = map('signature.show', {'n', 'i'}),
      ['<F12>'] = map('sclang.hard_stop', {'n', 'x', 'i'}),
      ['<leader>st'] = map('sclang.start'),
      ['<leader>sk'] = map('sclang.recompile'),
      ['<F1>'] = map_expr('s.boot'),
      ['<F2>'] = map_expr('s.meter'),
    },
    editor = {
      highlight = {
        color = 'IncSearch',
      },
    },
    postwin = {
      float = {
        enabled = true,
      },
    },
  })
end
