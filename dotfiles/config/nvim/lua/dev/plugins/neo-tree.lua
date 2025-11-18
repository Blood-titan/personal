return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",

    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },

    opts = {
        filesystem = {
            -- ⚠️ This stops neo-tree from replacing netrw
            hijack_netrw_behavior = "disabled",
        },
    },

    config = function(_, opts)
        -- Apply opts
        require("neo-tree").setup(opts)

        -- Your keymaps
        vim.keymap.set("n", "<C-n>", ":Neotree toggle<CR>")
        vim.keymap.set("n", "<leader>bf", ":Neotree buffers reveal float<CR>")
    end,
}
