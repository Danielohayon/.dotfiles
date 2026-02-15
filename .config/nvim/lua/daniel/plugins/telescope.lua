return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "princejoogie/dir-telescope.nvim",
    "nvim-telescope/telescope-live-grep-args.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local lga_actions = require("telescope-live-grep-args.actions")
    local previewers = require("telescope.previewers")
    local conf = require("telescope.config").values

    -- Function to get treesitter context for a specific line
    local function get_context_for_line(bufnr, target_line)
      local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
      if not ok or not parser then return {} end

      local context_lines = {}
      local trees = parser:parse()
      if not trees or not trees[1] then return {} end

      local root = trees[1]:root()
      local node = root:named_descendant_for_range(target_line - 1, 0, target_line - 1, 0)

      local seen = {}
      while node do
        local type = node:type()
        local start_row = node:start()

        if (type:match("function") or type:match("class") or type:match("method") or
            type:match("module") or type:match("def") or type:match("impl") or
            type:match("struct") or type:match("interface")) and
            start_row < target_line - 1 and not seen[start_row] then
          seen[start_row] = true
          local lines = vim.api.nvim_buf_get_lines(bufnr, start_row, start_row + 1, false)
          if lines[1] then
            table.insert(context_lines, 1, { line = lines[1], row = start_row + 1 })
          end
        end
        node = node:parent()
      end

      while #context_lines > 3 do table.remove(context_lines, 1) end
      return context_lines
    end

    -- Custom previewer with treesitter context
    local function create_context_previewer()
      return previewers.new_buffer_previewer({
        title = "Preview with Context",
        get_buffer_by_name = function(_, entry)
          return entry.filename or entry.path
        end,
        define_preview = function(self, entry, status)
          local filename = entry.filename or entry.path
          if not filename then return end
          local lnum = entry.lnum or 1

          -- Use the default file previewer first
          conf.buffer_previewer_maker(filename, self.state.bufnr, {
            bufname = self.state.bufname,
            winid = self.state.winid,
            callback = function(bufnr)
              if not vim.api.nvim_buf_is_valid(bufnr) then return end

              -- Delay to let buffer load fully
              vim.defer_fn(function()
                if not vim.api.nvim_buf_is_valid(bufnr) then return end
                if not vim.api.nvim_win_is_valid(self.state.winid) then return end

                -- Start treesitter for syntax highlighting
                pcall(vim.treesitter.start, bufnr)

                -- Get context
                local context = get_context_for_line(bufnr, lnum)

                if #context > 0 then
                  local ns = vim.api.nvim_create_namespace("telescope_ts_context")
                  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

                  -- Build all virtual lines in one structure
                  local virt_lines = {}
                  for i, ctx in ipairs(context) do
                    local prefix = i == #context and "└─ " or "├─ "
                    table.insert(virt_lines, { { prefix .. ctx.line:gsub("^%s+", ""), "DiagnosticInfo" } })
                  end
                  -- Add separator line
                  table.insert(virt_lines, { { string.rep("─", 50), "Comment" } })

                  -- Add all context as single extmark at the target line
                  pcall(vim.api.nvim_buf_set_extmark, bufnr, ns, math.max(0, lnum - 1), 0, {
                    virt_lines = virt_lines,
                    virt_lines_above = true,
                  })
                end

                -- Scroll to target line
                pcall(vim.api.nvim_win_set_cursor, self.state.winid, { lnum, 0 })
                pcall(vim.api.nvim_win_call, self.state.winid, function()
                  vim.cmd("normal! zz")
                end)
              end, 50)
            end,
          })
        end,
      })
    end

    telescope.setup({
      defaults = {
        cache_picker = {
          num_pickers = 30, -- keep last 30 searches in history
        },
        path_display = { "truncate " },
        layout_config = {
          preview_cutoff = 20,
          horizontal = {
            preview_width = 0.55,
          },
        },
        -- Show more context lines around match in preview
        preview = {
          treesitter = true,  -- syntax highlighting in preview
        },
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
    telescope.load_extension("file_browser")

    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
    keymap.set("n", "<leader>fF", "<cmd>Telescope find_files hidden=true<cr>", { desc = "Fuzzy find files (include hidden)" })
    keymap.set("n", "<leader>fe", "<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>", { desc = "File browser (current dir)" })
    keymap.set("n", "<leader>fE", "<cmd>Telescope file_browser<cr>", { desc = "File browser (cwd)" })
    keymap.set("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
    keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Open buffers" })
    keymap.set("n", "<leader>fs", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", { desc = "Find string in cwd (with args)" })
    keymap.set("n", "<leader>fS", function()
      require("telescope.builtin").live_grep({ previewer = create_context_previewer() })
    end, { desc = "Find string with context preview" })
    keymap.set("n", "<leader>fu", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
    keymap.set("n", "<leader>fU", function()
      require("telescope.builtin").grep_string({ previewer = create_context_previewer() })
    end, { desc = "Find string under cursor with context" })
    keymap.set("n", "<leader>fh", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Search In Current Buffer" })
    keymap.set("n", "<leader>fr", "<cmd>Telescope resume<cr>", { desc = "Continue Previous Search" })
    keymap.set("n", "<leader>fp", "<cmd>Telescope pickers<cr>", { desc = "Previous Searches" })
    keymap.set("n", "<leader>fy", "<cmd>Telescope neoclip<cr>", { desc = "Clipboard history" })

    keymap.set("n", "<leader>fd", "<cmd>Telescope dir live_grep<CR>", { noremap = true, silent = true, desc = "Live grep in directory" })
    keymap.set("n", "<leader>fv", "<cmd>Telescope command_history<cr>", { desc = "Command History" })
    keymap.set("n", "<leader>fj", "<cmd>Telescope jumplist<cr>", { desc = "*Jump History*" })
    keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "Keymaps" })
    -- Compare current file with another file (diff)
    keymap.set("n", "<leader>lc", function()
      local current_file = vim.fn.expand('%:p')
      if current_file == '' then
        vim.notify('No file in current buffer', vim.log.levels.WARN)
        return
      end
      require('telescope.builtin').find_files({
        prompt_title = 'Select file to compare with',
        attach_mappings = function(prompt_bufnr, map)
          actions.select_default:replace(function()
            local action_state = require('telescope.actions.state')
            local selection = action_state.get_selected_entry()
            actions.close(prompt_bufnr)
            if selection then
              vim.cmd('vert diffsplit ' .. vim.fn.fnameescape(selection.path))
              vim.defer_fn(function()
                vim.notify(
                  ']c/[c: next/prev change | do: obtain | dp: put | <leader>q to exit',
                  vim.log.levels.INFO
                )
              end, 100)
            end
          end)
          return true
        end,
      })
    end, { desc = "Compare file with another (diff)" })

    keymap.set("n", "<leader>fn", function()
      -- Use LSP symbols if available (has proper filtering), fallback to treesitter
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      if #clients > 0 then
        require("telescope.builtin").lsp_document_symbols({
          symbols = { "function", "method", "class", "struct", "interface" },
        })
      else
        -- Fallback: filter treesitter results manually
        local pickers = require("telescope.pickers")
        local finders = require("telescope.finders")
        local make_entry = require("telescope.make_entry")
        local ts_utils = require("nvim-treesitter.ts_utils")

        local bufnr = vim.api.nvim_get_current_buf()
        local ft = vim.bo[bufnr].filetype
        local ok, parser = pcall(vim.treesitter.get_parser, bufnr, ft)
        if not ok or not parser then return end

        local results = {}
        local tree = parser:parse()[1]
        local root = tree:root()

        local function_types = {
          "function_declaration", "function_definition", "method_declaration",
          "method_definition", "function", "arrow_function", "function_item",
          "class_declaration", "class_definition", "class", "struct_item",
          "interface_declaration", "type_alias_declaration",
        }
        local type_set = {}
        for _, t in ipairs(function_types) do type_set[t] = true end

        local function traverse(node)
          if type_set[node:type()] then
            local start_row, start_col = node:start()
            local name_node = node:field("name")[1]
            local name = name_node and vim.treesitter.get_node_text(name_node, bufnr) or "[anonymous]"
            table.insert(results, {
              lnum = start_row + 1,
              col = start_col + 1,
              text = name,
              kind = node:type(),
            })
          end
          for child in node:iter_children() do
            traverse(child)
          end
        end
        traverse(root)

        pickers.new({}, {
          prompt_title = "Functions & Classes",
          finder = finders.new_table({
            results = results,
            entry_maker = function(entry)
              return {
                value = entry,
                display = string.format("%s [%s]", entry.text, entry.kind:gsub("_", " ")),
                ordinal = entry.text,
                lnum = entry.lnum,
                col = entry.col,
                filename = vim.api.nvim_buf_get_name(bufnr),
              }
            end,
          }),
          sorter = conf.generic_sorter({}),
          previewer = conf.grep_previewer({}),
        }):find()
      end
    end, { desc = "Functions/classes in file" })
  end,
}
