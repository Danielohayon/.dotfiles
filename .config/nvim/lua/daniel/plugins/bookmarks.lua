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
    vim.keymap.set("n", "md", bm.bookmark_toggle, vim.tbl_extend("force", opts, { desc = "Delete bookmark at cursor" }))
    vim.keymap.set("n", "mB", bm.bookmark_clean, vim.tbl_extend("force", opts, { desc = "Clean bookmarks in buffer" }))
    vim.keymap.set("n", "mD", bm.bookmark_clear_all, vim.tbl_extend("force", opts, { desc = "Clear all bookmarks" }))
    -- vim.keymap.set("n", "mn", bm.bookmark_next, vim.tbl_extend("force", opts, { desc = "Next bookmark" }))
    -- vim.keymap.set("n", "mp", bm.bookmark_prev, vim.tbl_extend("force", opts, { desc = "Previous bookmark" }))
    -- vim.keymap.set("n", "mq", bm.bookmark_list, vim.tbl_extend("force", opts, { desc = "List bookmarks (quickfix)" }))
    vim.keymap.set("n", "ml", function()
      local finders = require("telescope.finders")
      local pickers = require("telescope.pickers")
      local previewers = require("telescope.previewers")
      local conf = require("telescope.config").values
      local bm_config = require("bookmarks.config").config

      local function get_text(annotation)
        local pref = string.sub(annotation, 1, 2)
        local ret = bm_config.keywords[pref]
        if ret == nil then
          ret = bm_config.signs.ann.text .. " "
        end
        return ret .. annotation
      end

      local allmarks = bm_config.cache.data
      local marklist = {}
      for k, ma in pairs(allmarks) do
        for l, v in pairs(ma) do
          table.insert(marklist, {
            filename = k,
            lnum = tonumber(l),
            text = v.a and get_text(v.a) or v.m,
            annotation = v.a or "",
          })
        end
      end

      -- Simple previewer that shows the full note
      local note_previewer = previewers.new_buffer_previewer({
        title = "Note",
        define_preview = function(self, entry)
          -- Enable word wrap in preview window
          vim.api.nvim_win_set_option(self.state.winid, "wrap", true)
          vim.api.nvim_win_set_option(self.state.winid, "linebreak", true)

          local lines = {}
          table.insert(lines, "File: " .. entry.filename)
          table.insert(lines, "Line: " .. entry.lnum)
          table.insert(lines, "")
          table.insert(lines, "--- Note ---")
          table.insert(lines, "")
          -- Add annotation text
          if entry.annotation == "" then
            table.insert(lines, "(no annotation)")
          else
            table.insert(lines, entry.annotation)
          end
          vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
        end,
      })

      pickers.new({
        layout_strategy = "horizontal",
        layout_config = { width = 0.7, height = 0.5, preview_width = 0.4 },
      }, {
        prompt_title = "bookmarks",
        finder = finders.new_table({
          results = marklist,
          entry_maker = function(entry)
            -- Show: short path + annotation preview
            local short_path = vim.fn.fnamemodify(entry.filename, ":t")
            local display_text = short_path .. ":" .. entry.lnum .. " │ " .. entry.text
            return {
              valid = true,
              value = entry,
              display = display_text,
              ordinal = entry.filename .. entry.text,
              filename = entry.filename,
              lnum = entry.lnum,
              col = 1,
              text = entry.text,
              annotation = entry.annotation,
            }
          end,
        }),
        sorter = conf.generic_sorter({}),
        previewer = note_previewer,
      }):find()
    end, vim.tbl_extend("force", opts, { desc = "List bookmarks (telescope)" }))

    require("telescope").load_extension("bookmarks")
  end,
}
