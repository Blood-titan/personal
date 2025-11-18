return {
    "goolord/alpha-nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "folke/tokyonight.nvim",

        -- Uncomment the session plugin you use:
        -- "rmagatti/auto-session",
        -- "jedrzejboczar/possession.nvim",
    },

    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        ---------------------------------------------------------
        --  BLOODTITAN ASCII LOGO
        ---------------------------------------------------------
        dashboard.section.header.val = {
            "░▒▓███████▓▒░░▒▓█▓▒░      ░▒▓██████▓▒░ ░▒▓██████▓▒░░▒▓███████▓▒░▒▓████████▓▒░▒▓█▓▒░▒▓████████▓▒░▒▓██████▓▒░░▒▓███████▓▒░",
            "░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░   ░▒▓█▓▒░  ░▒▓█▓▒░  ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░",
            "░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░   ░▒▓█▓▒░  ░▒▓█▓▒░  ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░",
            "░▒▓███████▓▒░░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░   ░▒▓█▓▒░  ░▒▓█▓▒░  ░▒▓████████▓▒░▒▓█▓▒░░▒▓█▓▒░",
            "░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░   ░▒▓█▓▒░  ░▒▓█▓▒░  ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░",
            "░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░   ░▒▓█▓▒░  ░▒▓█▓▒░  ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░",
            "░▒▓███████▓▒░░▒▓████████▓▒░▒▓██████▓▒░ ░▒▓██████▓▒░░▒▓███████▓▒░  ░▒▓█▓▒░   ░▒▓█▓▒░  ░▒▓█▓▒░  ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░",
            "",
        }

        ---------------------------------------------------------
        -- RANDOM QUOTES
        ---------------------------------------------------------
        local quotes = {
            "“Code is like humor. When you have to explain it, it’s bad.” – Cory House",
            "“Talk is cheap. Show me the code.” – Linus Torvalds",
            "“First, solve the problem. Then, write the code.” – John Johnson",
            "“Programs must be written for people to read.” – Harold Abelson",
            "“Simplicity is the soul of efficiency.” – Austin Freeman",
            "“Before software can be reusable it first has to be usable.” – Ralph Johnson",
        }
        math.randomseed(os.time())
        dashboard.section.footer.val = quotes[math.random(#quotes)]

        ---------------------------------------------------------
        -- SESSION BUTTONS
        ---------------------------------------------------------

        -- If you use auto-session:
        -- local session_button = dashboard.button("s", "  Restore session", ":SessionRestore<CR>")

        -- If you use possession.nvim:
        -- local session_button = dashboard.button("s", "  Restore session", ":PossessionLoad<CR>")

        -- Default (does nothing until you choose your plugin):
        local session_button = dashboard.button("s", "  Restore session", "<Nop>")

        ---------------------------------------------------------
        -- BUTTONS
        ---------------------------------------------------------
        dashboard.section.buttons.val = {
            dashboard.button("e", "  New file", ":ene<CR>"),
            dashboard.button("f", "  Find file", ":Telescope find_files<CR>"),
            dashboard.button("r", "  Recent files", ":Telescope oldfiles<CR>"),
            dashboard.button("g", "󰈞  Grep", ":Telescope live_grep<CR>"),
            session_button,
            dashboard.button("c", "  Config", ":e ~/.config/nvim/init.lua<CR>"),
            dashboard.button("q", "  Quit", ":qa<CR>"),
        }

        ---------------------------------------------------------
        -- FINAL SETUP
        ---------------------------------------------------------
        dashboard.opts.opts.noautocmd = true
        alpha.setup(dashboard.opts)
    end,
}
