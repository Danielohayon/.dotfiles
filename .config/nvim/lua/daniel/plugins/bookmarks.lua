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
      local cwd = vim.fn.getcwd()
      for k, ma in pairs(allmarks) do
        -- Only include bookmarks from current project
        if k:sub(1, #cwd) == cwd then
          for l, v in pairs(ma) do
            table.insert(marklist, {
              filename = k,
              lnum = tonumber(l),
              text = v.a and get_text(v.a) or v.m,
              annotation = v.a or "",
            })
          end
        end
      end

      -- Custom previewer: note on top, then code below (single buffer)
      local note_previewer = previewers.new_buffer_previewer({
        title = "Note & Code",
        define_preview = function(self, entry)
          -- Enable word wrap
          vim.api.nvim_win_set_option(self.state.winid, "wrap", true)
          vim.api.nvim_win_set_option(self.state.winid, "linebreak", true)

          local lines = {}
          local code_start_line = 0
          local code_prefix_len = 9  -- "  1234 | " = 9 chars (ASCII only)

          -- Add note section
          table.insert(lines, "-- Note " .. string.rep("-", 40))
          table.insert(lines, "")
          if entry.annotation == "" then
            table.insert(lines, "  (no annotation)")
          else
            for line in entry.annotation:gmatch("[^\n]+") do
              table.insert(lines, "  " .. line)
            end
          end
          table.insert(lines, "")
          table.insert(lines, string.rep("-", 48))
          table.insert(lines, "")

          -- Add file info
          table.insert(lines, "-- Code: " .. vim.fn.fnamemodify(entry.filename, ":t") .. ":" .. entry.lnum)
          code_start_line = #lines  -- 0-indexed line where code starts

          -- Read file content and add code context
          local ok, file_lines = pcall(vim.fn.readfile, entry.filename)
          local code_lines_raw = {}
          if ok then
            local start_line = math.max(1, entry.lnum - 5)
            local end_line = math.min(#file_lines, entry.lnum + 10)
            for i = start_line, end_line do
              local prefix = i == entry.lnum and "> " or "  "
              local line_num = string.format("%4d", i)
              table.insert(lines, prefix .. line_num .. " | " .. (file_lines[i] or ""))
              table.insert(code_lines_raw, file_lines[i] or "")
            end
          end

          vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)

          -- Apply syntax highlighting to code section using treesitter
          -- Parse the FULL file for correct context, but only highlight displayed lines
          local ft = vim.filetype.match({ filename = entry.filename })
          if ft and ok and #file_lines > 0 then
            local full_text = table.concat(file_lines, "\n")
            local ts_ok, parser = pcall(vim.treesitter.get_string_parser, full_text, ft)
            if ts_ok and parser then
              local tree = parser:parse()[1]
              if tree then
                local query_ok, query = pcall(vim.treesitter.query.get, ft, "highlights")
                if query_ok and query then
                  local ns = vim.api.nvim_create_namespace("bookmark_preview_hl")
                  local display_start = math.max(1, entry.lnum - 5)
                  local display_end = math.min(#file_lines, entry.lnum + 10)

                  for id, node in query:iter_captures(tree:root(), full_text, display_start - 1, display_end) do
                    local name = query.captures[id]
                    local hl = "@" .. name .. "." .. ft
                    if vim.fn.hlexists(hl) == 0 then
                      hl = "@" .. name
                    end
                    local start_row, start_col, end_row, end_col = node:range()

                    -- Only highlight if within our displayed range
                    if start_row >= display_start - 1 and start_row < display_end then
                      -- Convert file line to buffer line
                      local buf_start_row = code_start_line + (start_row - (display_start - 1))
                      local buf_end_row = code_start_line + (end_row - (display_start - 1))
                      local buf_start_col = code_prefix_len + start_col
                      local buf_end_col = code_prefix_len + end_col

                      -- Clamp end row to displayed range
                      if buf_end_row > code_start_line + (display_end - display_start) then
                        buf_end_row = code_start_line + (display_end - display_start)
                        buf_end_col = #lines[buf_end_row + 1] or 0
                      end

                      pcall(vim.api.nvim_buf_set_extmark, self.state.bufnr, ns, buf_start_row, buf_start_col, {
                        end_row = buf_end_row,
                        end_col = buf_end_col,
                        hl_group = hl,
                      })
                    end
                  end
                end
              end
            end
          end

          -- Highlight the bookmark line marker
          local ns = vim.api.nvim_create_namespace("bookmark_preview_marker")
          for i, line in ipairs(lines) do
            if line:sub(1, 1) == ">" then
              pcall(vim.api.nvim_buf_set_extmark, self.state.bufnr, ns, i - 1, 0, {
                end_col = 1,
                hl_group = "WarningMsg",
              })
            end
          end
        end,
      })

      pickers.new({
        layout_strategy = "horizontal",
        layout_config = { width = 0.8, height = 0.7, preview_width = 0.5 },
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
