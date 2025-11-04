return {
  "folke/snacks.nvim",
  opts = {
    image = {
      enabled = true,
      backend = "kitty",  -- Ghostty supports kitty protocol
      doc = {
        enabled = true,
        inline = true,
        float = true,
        conceal = false,
        max_width = 60,   -- Reduce image width
        max_height = 20,  -- Reduce image height
      },
      integrations = {
        markdown = true,  -- Enable markdown image preview
      },
    },
  },
}
