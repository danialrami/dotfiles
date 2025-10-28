return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },
  
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls", -- Lua
          "pyright", -- Python
          -- "ts_ls", -- JavaScript/TypeScript
          "rust_analyzer", -- Rust
          "cssls", -- CSS
          "html", -- HTML
          "jsonls", -- JSON
          "tailwindcss", -- Tailwind CSS
          -- "gopls", -- Go (commented out)
          "clangd", -- C/C++
        }
      })
    end
  },
  
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "j-hui/fidget.nvim",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      
      -- Configure Lua LSP using new vim.lsp.config API
      vim.lsp.config.lua_ls = {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" }
            }
          }
        }
      }
      vim.lsp.enable('lua_ls')
      
      -- Configure other servers using new API
      local servers = {
        { name = "pyright", filetypes = { "python" } },
        { name = "rust_analyzer", filetypes = { "rust" } },
        { name = "cssls", filetypes = { "css", "scss", "less" } },
        { name = "html", filetypes = { "html" } },
        { name = "jsonls", filetypes = { "json", "jsonc" } },
        { name = "tailwindcss", filetypes = { "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact" } },
        { name = "clangd", filetypes = { "c", "cpp", "objc", "objcpp" } },
      }
      
      for _, server in ipairs(servers) do
        vim.lsp.config[server.name] = {
          capabilities = capabilities,
          filetypes = server.filetypes,
        }
        vim.lsp.enable(server.name)
      end
      
      -- LSP Keybindings
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, {})
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {})
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, {})
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, {})
    end
  },
  
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require("cmp")
      require("luasnip.loaders.from_vscode").lazy_load()
      
      cmp.setup({
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping.select_next_item(),
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
        })
      })
    end
  },
  
  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    config = function()
      require("fidget").setup()
    end
  }
}
