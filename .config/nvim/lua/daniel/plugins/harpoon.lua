local M = {
  "ThePrimeagen/harpoon",
  -- event = "VeryLazy",
-- "VeryLazy"
  dependencies = {
    { "nvim-lua/plenary.nvim" },
  },
}

function M.config()
  local keymap = vim.keymap.set
  local opts = { noremap = true, silent = true }
	require("telescope").load_extension('harpoon')

  keymap("n", "mm", "<cmd>lua require('daniel.plugins.harpoon').mark_file()<cr>", { noremap = true, silent = true, desc = "Mark File" })
  keymap("n", "mv", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", { noremap = true, silent = true, desc = "Harpoon View" })
  keymap("n", "mc", "<cmd>Telescope harpoon marks<cr>", { noremap = true, silent = true, desc = "Telescope view" })
  keymap("n", "mj", "<cmd>lua require('harpoon.ui').nav_prev()<cr>", { noremap = true, silent = true, desc = "Prev Catch" })
  keymap("n", "mk", "<cmd>lua require('harpoon.ui').nav_next()<cr>", { noremap = true, silent = true, desc = "Next Catch" })

  keymap("n", "ma", "<cmd>lua require('harpoon.ui').nav_file(1)<cr>", { noremap = true, silent = true, desc = "Catch 1" })
  keymap("n", "ms", "<cmd>lua require('harpoon.ui').nav_file(2)<cr>", { noremap = true, silent = true, desc = "Catch 2" })
  keymap("n", "md", "<cmd>lua require('harpoon.ui').nav_file(3)<cr>", { noremap = true, silent = true, desc = "Catch 3" })
  keymap("n", "mf", "<cmd>lua require('harpoon.ui').nav_file(4)<cr>", { noremap = true, silent = true, desc = "Catch 4" })
  keymap("n", "mg", "<cmd>lua require('harpoon.ui').nav_file(5)<cr>", { noremap = true, silent = true, desc = "Catch 5" })
  keymap("n", "mh", "<cmd>lua require('harpoon.ui').nav_file(6)<cr>", { noremap = true, silent = true, desc = "Catch 6" })
  vim.api.nvim_create_autocmd({ "filetype" }, {
    pattern = "harpoon",
    callback = function()
      vim.cmd [[highlight link HarpoonBorder TelescopeBorder]]
      -- vim.cmd [[setlocal nonumber]]
      -- vim.cmd [[highlight HarpoonWindow guibg=#313132]]
    end,
  })
end

function M.mark_file()
  require("harpoon.mark").add_file()
  vim.notify "󱡅  marked file"
end

return M
