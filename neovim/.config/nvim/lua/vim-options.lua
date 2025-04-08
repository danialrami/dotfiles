-- Set leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Indentation
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

-- System clipboard
vim.opt.clipboard = "unnamedplus"

-- Additional recommended options you might want:
vim.opt.number = true          -- Show line numbers
vim.opt.relativenumber = true  -- Show relative line numbers
vim.opt.wrap = false          -- Display long lines as just one line
vim.opt.ignorecase = true     -- Ignore case in search patterns
vim.opt.smartcase = true      -- Override ignorecase if search pattern contains uppercase
vim.opt.cursorline = true     -- Highlight the current line

-- Line wrapping
vim.opt.wrap = true         -- enable line wrapping
vim.opt.linebreak = true    -- wrap at word boundaries
vim.opt.textwidth = 0       -- prevent hard wrapping
vim.opt.wrapmargin = 0      -- prevent automatic line breaks
