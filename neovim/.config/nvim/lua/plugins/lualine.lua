return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require('lualine').setup({
            options = {
                theme = 'moonfly',
                component_separators = '|',
                section_separators = { left = '', right = '' },
            },
        })
    end
}

