return {
  "nvim-treesitter/nvim-treesitter-context",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  event = "BufReadPost",
  opts = {
    enable = true,
    max_lines = 3,           -- max lines to show at top
    min_window_height = 20,  -- disable if window too small
    multiline_threshold = 1, -- max lines for a single context line
    trim_scope = "outer",
    mode = "cursor",         -- show context based on cursor position
  },
  keys = {
    { "<leader>tc", "<cmd>TSContextToggle<cr>", desc = "Toggle treesitter context" },
  },
}
