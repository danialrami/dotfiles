return {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
      input = {
        default_prompt = "Input:",
        prompt_align = "left",
        insert_only = true,
        border = "rounded",
        relative = "cursor",
      },
      select = {
        backend = { "telescope", "builtin" },
        builtin = {
          border = "rounded",
          relative = "cursor",
        },
      },
    },
  }
  