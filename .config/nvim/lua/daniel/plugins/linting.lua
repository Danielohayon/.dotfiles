return {
  "mfussenegger/nvim-lint",
  lazy = true,
  event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      python = { "mypy" },
    }

    -- Auto-lint disabled - was causing gutter sign conflicts
    -- local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
    -- vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost"}, {
    --   pattern = { "*.py" },
    --   group = lint_augroup,
    --   callback = function()
    --     lint.try_lint()
    --   end,
    -- })

    vim.keymap.set("n", "<leader>ll", function()
      lint.try_lint()
    end, { desc = "Trigger linting for current file" })
  end,
}
