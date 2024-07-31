return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        path_display = { "truncate " },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
      },
    })

    telescope.load_extension("fzf")
    telescope.load_extension("dir")

    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
    keymap.set("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
    keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
    keymap.set("n", "<leader>fu", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
    keymap.set("n", "<leader>fh", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Search In Current Buffer" })
    keymap.set("n", "<leader>fr", "<cmd>Telescope resume<cr>", { desc = "Continue Previous Search" })
    keymap.set("n", "<leader>fp", "<cmd>Telescope pickers<cr>", { desc = "Previous Searches" })
    keymap.set("n", "<leader>fy", "<cmd>Telescope neoclip<cr>", { desc = "Previous Searches" })

    keymap.set("n", "<leader>fd", "<cmd>Telescope dir live_grep<CR>", { noremap = true, silent = true })
    keymap.set("n", "<leader>fv", "<cmd>Telescope command_history<cr>", { desc = "Command History" })
    keymap.set("n", "<leader>fj", "<cmd>Telescope jumplist<cr>", { desc = "*Jump History*" })
    keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "Keymaps" })

    telescope.load_extension('dap')
  end,
}
