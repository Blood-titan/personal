return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "stevearc/conform.nvim",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "j-hui/fidget.nvim",
  },

  config = function()
    -- ✅ Formatting setup
    require("conform").setup({
      formatters_by_ft = {
        python = { "black", "ruff_fix", "ruff_format" },
        lua = { "stylua" },
        json = { "jq" },
        markdown = { "prettier" },
      },
    })

    -- ✅ Completion
    local cmp = require("cmp")
    local cmp_lsp = require("cmp_nvim_lsp")
    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      cmp_lsp.default_capabilities()
    )

    -- ✅ UI and helpers
    require("fidget").setup({})
    require("mason").setup()

    -- ✅ LSP setup
    require("mason-lspconfig").setup({
      ensure_installed = {
        -- ML / Data Science essentials
        --"pyright",            -- Better Python LSP
        --"ruff",           -- Linting, imports, etc.
        --"jupyter",            -- Jupyter notebooks
        --"json",             -- Configs
        --"bash",             -- Scripts
        "lua_ls",             -- For Neovim config
      },
      handlers = {
        function(server_name)
          require("lspconfig")[server_name].setup({
            capabilities = capabilities,
          })
        end,

        -- 🧠 Python setup (for ML)
        ["pyright"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.pyright.setup({
            capabilities = capabilities,
            settings = {
              python = {
                analysis = {
                  typeCheckingMode = "off", -- Use Ruff instead
                  autoSearchPaths = true,
                  useLibraryCodeForTypes = true,
                  diagnosticMode = "workspace",
                },
              },
            },
          })
        end,

        -- ⚙️ Ruff setup (linter + formatter)
        ["ruff_lsp"] = function()
          require("lspconfig").ruff_lsp.setup({
            capabilities = capabilities,
            init_options = {
              settings = {
                args = { "--line-length=100" },
              },
            },
          })
        end,

        -- 🪶 Lua setup
        ["lua_ls"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.lua_ls.setup({
            capabilities = capabilities,
            settings = {
              Lua = {
                format = {
                  enable = true,
                  defaultConfig = {
                    indent_style = "space",
                    indent_size = "2",
                  },
                },
                diagnostics = { globals = { "vim" } },
              },
            },
          })
        end,
      },
    })

    -- ✅ Completion settings
    local cmp_select = { behavior = cmp.SelectBehavior.Select }

    cmp.setup({
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
            mapping = cmp.mapping.preset.insert({    ["<Tab>"] = cmp.mapping.select_next_item(),
                ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                ["<CR>"] = cmp.mapping.confirm({ select = true }),
                ["<C-e>"] = cmp.mapping.abort(),
                ["<C-Space>"] = cmp.mapping.complete(),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "path" },
      }, {
        { name = "buffer" },
      }),
    })

    -- ✅ Diagnostics style
    vim.diagnostic.config({
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
      update_in_insert = false,
      severity_sort = true,
    })

    -- ✅ Common LSP keymaps
    local on_attach = function(_, bufnr)
      local opts = { buffer = bufnr }
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
    end
  end,
}

