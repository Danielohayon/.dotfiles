local function diffview_commit_picker()
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  require("telescope.builtin").git_commits({
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if selection then
          vim.cmd("DiffviewOpen " .. selection.value)
        end
      end)
      return true
    end,
  })
end

return {
  "sindrets/diffview.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons", "nvim-telescope/telescope.nvim" },
  cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
  keys = {
    { "<leader>go", "<cmd>DiffviewOpen<cr>", desc = "Diffview: Open (working tree)" },
    { "<leader>gO", ":DiffviewOpen ", desc = "Diffview: Open (enter ref)" },
    { "<leader>gp", diffview_commit_picker, desc = "Diffview: Pick commit to diff" },
    { "<leader>gH", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview: File history" },
    { "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Diffview: Close" },
  },
  config = function()
    local actions = require("diffview.actions")
    require("diffview").setup({
      view = {
        default = { layout = "diff2_horizontal" },
        merge_tool = { layout = "diff3_horizontal" },
      },
      file_panel = {
        listing_style = "tree",
        win_config = { position = "left", width = 35 },
      },
      keymaps = {
        view = {
          { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
          { "n", "<leader>gq", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
        },
        file_panel = {
          { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
          { "n", "<leader>gq", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
        },
        file_history_panel = {
          { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
          { "n", "<leader>gq", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
        },
      },
    })
  end,
}
