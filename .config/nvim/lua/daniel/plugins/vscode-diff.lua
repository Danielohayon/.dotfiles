return {
  "esmuellert/vscode-diff.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  cmd = "CodeDiff",
  keys = {
    { "<leader>gd", "<cmd>CodeDiff<cr>", desc = "Git diff (vscode style)" },
    { "<leader>gD", "<cmd>CodeDiff file HEAD<cr>", desc = "Diff current file vs HEAD" },
  },
  config = function()
    require("vscode-diff").setup({
      keymaps = {
        view = {
          quit = { "q", "<Esc>" },
          toggle_explorer = "<leader>b",
          next_hunk = "]c",
          prev_hunk = "[c",
        },
        explorer = {
          select = "<CR>",
          hover = "K",
          refresh = "R",
          quit = { "q", "<Esc>" },
        },
      },
    })
  end,
}
