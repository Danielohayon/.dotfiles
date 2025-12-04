return {
  "tomasky/bookmarks.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-telescope/telescope.nvim" },
  config = function()
    local bm = require("bookmarks")
    bm.setup({
      save_file = vim.fn.expand("$HOME/Documents/Projects/Notes/Projects/.nvim_bookmarks"),
      keywords = {
        ["@t"] = "󰄱 ", -- todo
        ["@w"] = "󰀪 ", -- warning
        ["@n"] = "󰎚 ", -- note
        ["@q"] = "? ", -- question
      },
    })

    -- Global keymaps (fast access without leader)
    local opts = { silent = true }
    vim.keymap.set("n", "mm", bm.bookmark_toggle, vim.tbl_extend("force", opts, { desc = "Toggle bookmark" }))
    vim.keymap.set("n", "ma", bm.bookmark_ann, vim.tbl_extend("force", opts, { desc = "Add/edit bookmark annotation" }))
    vim.keymap.set("n", "mc", bm.bookmark_clean, vim.tbl_extend("force", opts, { desc = "Clean bookmarks in buffer" }))
    vim.keymap.set("n", "mC", bm.bookmark_clear_all, vim.tbl_extend("force", opts, { desc = "Clear all bookmarks" }))
    -- vim.keymap.set("n", "mn", bm.bookmark_next, vim.tbl_extend("force", opts, { desc = "Next bookmark" }))
    -- vim.keymap.set("n", "mp", bm.bookmark_prev, vim.tbl_extend("force", opts, { desc = "Previous bookmark" }))
    -- vim.keymap.set("n", "mq", bm.bookmark_list, vim.tbl_extend("force", opts, { desc = "List bookmarks (quickfix)" }))
    vim.keymap.set("n", "ml", "<cmd>Telescope bookmarks list<cr>", vim.tbl_extend("force", opts, { desc = "List bookmarks (telescope)" }))

    require("telescope").load_extension("bookmarks")
  end,
}
