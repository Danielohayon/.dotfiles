local function diffview_commit_picker()
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local previewers = require("telescope.previewers")
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values

  local git_log = vim.fn.systemlist('git log --pretty=format:"%H|||%h|||%an|||%s" -200')

  pickers.new({}, {
    prompt_title = "Select commit for diffview",
    finder = finders.new_table({
      results = git_log,
      entry_maker = function(entry)
        local full_hash, short_hash, author, message = entry:match('(.-)|||(.-)|||(.-)|||(.+)')
        if not full_hash then return nil end
        return {
          value = short_hash,
          display = string.format("%s  %-20s  %s", short_hash, author, message),
          ordinal = short_hash .. " " .. author .. " " .. message,
          full_hash = full_hash,
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    previewer = previewers.new_termopen_previewer({
      get_command = function(entry)
        return { "git", "show", "--stat", "--color=always", entry.full_hash }
      end,
    }),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if selection then
          vim.cmd("DiffviewOpen " .. selection.value)
        end
      end)
      return true
    end,
  }):find()
end

return {
  "KEY60228/alt-diffview.nvim",
  branch = "fix/show-untracked-files",
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
          { "n", "-", actions.toggle_stage_entry, { desc = "Stage/unstage file" } },
          { "n", "S", actions.stage_all, { desc = "Stage all files" } },
          { "n", "U", actions.unstage_all, { desc = "Unstage all files" } },
          { "n", "X", actions.restore_entry, { desc = "Restore file to previous state" } },
        },
        file_history_panel = {
          { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
          { "n", "<leader>gq", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
        },
      },
    })
  end,
}
