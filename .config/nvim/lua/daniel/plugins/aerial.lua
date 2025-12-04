return {
  "stevearc/aerial.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  cmd = { "AerialToggle", "AerialOpen" },
  keys = {
    { "<leader>co", "<cmd>AerialToggle<cr>", desc = "Code outline" },
    { "<leader>cn", "<cmd>AerialNext<cr>", desc = "Next symbol" },
    { "<leader>cp", "<cmd>AerialPrev<cr>", desc = "Previous symbol" },
  },
  opts = {
    backends = { "treesitter", "lsp" },
    layout = {
      min_width = 30,
      default_direction = "right",
    },
    show_guides = true,
    filter_kind = false,  -- show all symbols
  },
}
