-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- :Now command to insert timestamp on the current line (copies the current logic in Obsidian)
vim.api.nvim_create_user_command('Now', function()
    local time = vim.fn.strftime("%l:%M %p"):gsub("^%s+", ""):lower()
    local lines = { "---", "## " .. time, "", "" }
    local row = vim.fn.line('.') - 1  -- Get current line (0-indexed)
    vim.api.nvim_buf_set_lines(0, row, row + 1, false, lines)  -- Replace current line with new content
    vim.fn.cursor(row + 4, 1)  -- Move cursor to the blank line where you'll write
    vim.cmd.startinsert()
  end, {})
  
  -- Leader keymap to trigger :Now
  vim.keymap.set('n', '<leader>\\', ':Now<CR>', { noremap = true, silent = true, desc = 'Insert timestamp' })

  