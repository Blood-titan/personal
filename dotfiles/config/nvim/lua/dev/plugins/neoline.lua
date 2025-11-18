return {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "folke/tokyonight.nvim",
    },

    config = function()
        require("lualine").setup({
            options = {
                theme = "tokyonight",
                icons_enabled = true,
                globalstatus = true,
                section_separators = "",
                component_separators = "│",
            },

            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch", "diff" },
                lualine_c = {
                    { "filename", path = 1 },
                },
                lualine_x = {
                    "diagnostics",
                    "encoding",
                    "filetype",
                    { function() return os.date("%H:%M") end, icon = "" }, -- ⏰ TIME
                },
                lualine_y = { "progress" },
                lualine_z = { "location" },
            },
        })
    end,
}
