return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "princejoogie/dir-telescope.nvim",
    "nvim-telescope/telescope-live-grep-args.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local lga_actions = require("telescope-live-grep-args.actions")

    telescope.setup({
      defaults = {
        cache_picker = {
          num_pickers = 30, -- keep last 30 searches in history
        },
        path_display = { "truncate " },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
      },
      extensions = {
        live_grep_args = {
          auto_quoting = true,
          mappings = {
            i = {
              ["<C-r>"] = lga_actions.quote_prompt({ postfix = " -g " }),  -- add glob filter
              ["<C-t>"] = lga_actions.quote_prompt({ postfix = " -t " }),  -- add type filter
              ["<C-f>"] = lga_actions.quote_prompt({ postfix = " -F" }),   -- fixed string (literal match)
              ["<C-h>"] = lga_actions.quote_prompt({ postfix = " --hidden" }),  -- include hidden files
              ["<C-space>"] = lga_actions.to_fuzzy_refine,  -- fuzzy filter results
            },
          },
        },
      },
    })

    telescope.load_extension("fzf")
    telescope.load_extension("dir")
    telescope.load_extension("live_grep_args")

    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
    keymap.set("n", "<leader>fF", "<cmd>Telescope find_files hidden=true<cr>", { desc = "Fuzzy find files (include hidden)" })
    keymap.set("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
    keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Open buffers" })
    keymap.set("n", "<leader>fs", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", { desc = "Find string in cwd (with args)" })
    keymap.set("n", "<leader>fu", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
    keymap.set("n", "<leader>fh", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Search In Current Buffer" })
    keymap.set("n", "<leader>fr", "<cmd>Telescope resume<cr>", { desc = "Continue Previous Search" })
    keymap.set("n", "<leader>fp", "<cmd>Telescope pickers<cr>", { desc = "Previous Searches" })
    keymap.set("n", "<leader>fy", "<cmd>Telescope neoclip<cr>", { desc = "Previous Searches" })

    keymap.set("n", "<leader>fd", "<cmd>Telescope dir live_grep<CR>", { noremap = true, silent = true })
    keymap.set("n", "<leader>fv", "<cmd>Telescope command_history<cr>", { desc = "Command History" })
    keymap.set("n", "<leader>fj", "<cmd>Telescope jumplist<cr>", { desc = "*Jump History*" })
    keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "Keymaps" })
  end,
}
