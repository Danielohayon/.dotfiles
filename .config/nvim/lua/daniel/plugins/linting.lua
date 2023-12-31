return {
  "mfussenegger/nvim-lint",
  lazy = true,
  event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      python = { "pylint" },
    }

    -- local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

   --  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost"}, { -- Aslo "InsertLeave" is possible but because pylint only works on saved files it is useless to include InsertLeave here
			-- pattern = { "*.py", "*.ipynb" }, -- only run on python files
   --    group = lint_augroup,
   --    callback = function()
   --      lint.try_lint()
   --    end,
   --  })

    vim.keymap.set("n", "<leader>ll", function()
      lint.try_lint()
    end, { desc = "Trigger linting for current file" })
  end,
}
