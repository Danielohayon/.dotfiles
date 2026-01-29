return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  config = function()
    local wk = require("which-key")
    wk.setup({
      delay = 0,
    })

    -- Register group names for leader key prefixes
    wk.add({
      { "<leader>c", group = "Code" },
      { "<leader>d", group = "Debug" },
      { "<leader>f", group = "Find/Search" },
      { "<leader>g", group = "Git" },
      { "<leader>gh", group = "Git Hunk" },
      { "<leader>gt", group = "Git Toggle" },
      { "<leader>l", group = "LSP/Code" },
      { "<leader>li", group = "Indent" },
      { "<leader>lw", group = "Workspace" },
      { "<leader>m", group = "Marks/Harpoon" },
      { "<leader>s", group = "Split" },
      { "<leader>t", group = "Terminal" },
      { "g", group = "Go to" },
      { "m", group = "Bookmarks/Buffers" },
      { "z", group = "Folds/View" },
    })
  end,
}
