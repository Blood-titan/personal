return {
  {
    "kiyoon/jupynium.nvim",
    build = ":UpdateRemotePlugins",
    ft = { "python", "julia", "r" },
    dependencies = {
      "rcarriga/nvim-notify",
      "stevearc/dressing.nvim",
    },
    config = function()
      require("jupyter").setup()
    end,
  },
}

