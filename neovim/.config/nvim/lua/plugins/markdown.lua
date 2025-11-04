return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      -- Enable rendering in normal, insert, and command modes
      render_modes = { 'n', 'i', 'c' },
      heading = {
        -- Use icons for headings
        sign = false,
        icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
      },
      code = {
        sign = false,
        style = 'full',
        width = 'full',
        border = 'thin',
      },
      checkbox = {
        enabled = true,
      },
      -- DISABLE image rendering in render-markdown
      -- This lets Snacks.image handle inline image rendering
      image = {
        enabled = false,
      },
    },
  },
}
