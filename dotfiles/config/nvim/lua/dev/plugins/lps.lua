return {
    "neovim/nvim-lspconfig",

    dependencies = {
        "stevearc/conform.nvim",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",

        -- Completion
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-cmdline",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",

        -- UI
        "j-hui/fidget.nvim",
    },

    config = function()
        ------------------------------
        -- Formatting (Conform)
        ------------------------------
        require("conform").setup({
            format_on_save = {
                timeout_ms = 2000,
                lsp_fallback = true,
            },
            formatters_by_ft = {
                python = { "black", "ruff_fix", "ruff_format" },
                lua = { "stylua" },
                json = { "jq" },
                markdown = { "prettier" },
            },
        })

        ------------------------------
        -- Completion (cmp)
        ------------------------------
        local cmp = require("cmp")
        local cmp_lsp = require("cmp_nvim_lsp")

        local capabilities = cmp_lsp.default_capabilities()

        cmp.setup({
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ["<Tab>"] = cmp.mapping.select_next_item(),
                ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                ["<CR>"] = cmp.mapping.confirm({ select = true }),
            }),
            sources = {
                { name = "nvim_lsp" },
                { name = "path" },
                { name = "buffer" },
            },
        })

        ------------------------------
        -- UI tools
        ------------------------------
        require("fidget").setup({})
        require("mason").setup()

        ------------------------------
        -- LSP Keymaps
        ------------------------------
        local on_attach = function(_, bufnr)
            local opts = { buffer = bufnr }

            vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
            vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
            vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
        end

        ------------------------------
        -- Mason LSP
        ------------------------------
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
            },

            handlers = {

                -- Default handler
                function(server_name)
                    require("lspconfig")[server_name].setup({
                        on_attach = on_attach,
                        capabilities = capabilities,
                    })
                end,

                -----------------------------------
                -- Python: Pyright
                -----------------------------------
                ["pyright"] = function()
                    require("lspconfig").pyright.setup({
                        on_attach = on_attach,
                        capabilities = capabilities,
                        settings = {
                            python = {
                                analysis = {
                                    typeCheckingMode = "off", -- Ruff handles this
                                    autoSearchPaths = true,
                                    useLibraryCodeForTypes = true,
                                },
                            },
                        },
                    })
                end,

                -----------------------------------
                -- Python: Ruff LSP
                -----------------------------------
                ["ruff_lsp"] = function()
                    require("lspconfig").ruff_lsp.setup({
                        on_attach = on_attach,
                        capabilities = capabilities,
                        init_options = {
                            settings = {
                                args = { "--line-length=100" },
                            },
                        },
                    })
                end,

                -----------------------------------
                -- Lua: Stylua formatting + globals
                -----------------------------------
                ["lua_ls"] = function()
                    require("lspconfig").lua_ls.setup({
                        on_attach = on_attach,
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                diagnostics = { globals = { "vim" } },
                                format = {
                                    enable = true,
                                    defaultConfig = {
                                        indent_style = "space",
                                        indent_size = "2",
                                    },
                                },
                            },
                        },
                    })
                end,
            },
        })

        ------------------------------
        -- Diagnostics
        ------------------------------
        vim.diagnostic.config({
            float = { border = "rounded" },
            severity_sort = true,
        })
    end,
}
