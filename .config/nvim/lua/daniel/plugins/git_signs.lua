return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  -- config = true,
  config = function()
    -- import comment plugin safely
    local gitsigns = require("gitsigns")
    gitsigns.setup({
      sign_priority = 100,  -- High priority so git signs aren't overridden
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				map('n', ']c', function()
					if vim.wo.diff then return ']c' end
					vim.schedule(function() gs.next_hunk() end)
					return '<Ignore>'
				end, {expr=true, desc = "Next git hunk"})

				map('n', '[c', function()
					if vim.wo.diff then return '[c' end
					vim.schedule(function() gs.prev_hunk() end)
					return '<Ignore>'
				end, {expr=true, desc = "Previous git hunk"})

				-- Actions
				map('n', '<leader>ghs', gs.stage_hunk, { desc = "Stage Hunk" })
				map('n', '<leader>ghr', gs.reset_hunk, { desc = "Reset Hunk" })
				map('v', '<leader>gha', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = "Stage Hunk" })
				map('v', '<leader>ghr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = "Reset Hunk" })
				map('n', '<leader>ga', gs.stage_buffer, { desc = "Stage Buffer" })
				map('n', '<leader>ghu', gs.undo_stage_hunk, {desc = "Undo Stage Hunk" })
				map('n', '<leader>gR', gs.reset_buffer, {desc = "Reset Buffer" })
				map('n', '<leader>ghp', gs.preview_hunk, {desc = "Preview Hunk" })
				map('n', '<leader>gb', function() gs.blame_line{full=true} end, { desc = "Blame Line" })
				map('n', '<leader>gtb', gs.toggle_current_line_blame, {desc = "Toggle Current Line Blame" })
				-- Diff with easy close - q returns to original buffer
				local function diff_with_close(base)
					local original_win = vim.api.nvim_get_current_win()
					local original_buf = vim.api.nvim_get_current_buf()
					local wins_before = vim.api.nvim_list_wins()
					gs.diffthis(base)

					vim.schedule(function()
						-- Find the new window (diff window)
						local diff_win = nil
						local diff_buf = nil
						for _, win in ipairs(vim.api.nvim_list_wins()) do
							if not vim.tbl_contains(wins_before, win) then
								diff_win = win
								diff_buf = vim.api.nvim_win_get_buf(win)
								break
							end
						end

						-- Function to close diff and return to original
						local function close_diff()
							vim.cmd("diffoff!")
							-- Close the diff window
							if diff_win and vim.api.nvim_win_is_valid(diff_win) then
								vim.api.nvim_win_close(diff_win, true)
							end
							vim.cmd("diffoff!")
							-- Return to original
							if vim.api.nvim_win_is_valid(original_win) then
								vim.api.nvim_set_current_win(original_win)
							end
							-- Remove q mapping from original buffer
							pcall(vim.keymap.del, 'n', 'q', { buffer = original_buf })
						end

						-- Add q mapping to original buffer
						vim.keymap.set('n', 'q', close_diff, { buffer = original_buf, desc = "Close diff" })

						-- Add q mapping to diff buffer if found
						if diff_buf then
							vim.keymap.set('n', 'q', close_diff, { buffer = diff_buf, desc = "Close diff" })
						end
					end)
				end

				map('n', '<leader>gd', function() diff_with_close() end, {desc = "Diff File" })
				map('n', '<leader>gD', function() diff_with_close('~') end, {desc = "Diff File vs parent" })
				map('n', '<leader>gm', function() diff_with_close('main') end, {desc = "Diff File vs main" })
				map('n', '<leader>gtd', gs.toggle_deleted, { desc = "Toggle Deleted" })

				-- Toggle gitsigns base between index and merge-base with main
				local merge_base_active = false
				local function toggle_merge_base()
					if merge_base_active then
						gs.reset_base(true)
						merge_base_active = false
						vim.g.gitsigns_base_commit = nil
						vim.notify("Gitsigns: Showing diffs against index", vim.log.levels.INFO)
					else
						local merge_base = vim.fn.system("git merge-base main HEAD"):gsub('\n', '')
						if vim.v.shell_error ~= 0 then
							vim.notify("Failed to get merge-base with main", vim.log.levels.ERROR)
							return
						end
						gs.change_base(merge_base, true)
						merge_base_active = true
						vim.g.gitsigns_base_commit = merge_base
						vim.notify("Gitsigns: Showing diffs since branch from main", vim.log.levels.INFO)
					end
				end
				map('n', '<leader>gB', toggle_merge_base, { desc = "Toggle merge-base diff" })

				-- Select a commit from Telescope to use as gitsigns base
				local function select_base_commit()
					require('telescope.builtin').git_commits({
						attach_mappings = function(prompt_bufnr, map_fn)
							local actions = require('telescope.actions')
							local action_state = require('telescope.actions.state')

							actions.select_default:replace(function()
								local selection = action_state.get_selected_entry()
								actions.close(prompt_bufnr)
								if selection then
									local commit_hash = selection.value
									require('gitsigns').change_base(commit_hash, true)
									vim.g.gitsigns_base_commit = commit_hash
									vim.notify("Gitsigns: Base set to " .. commit_hash:sub(1, 7), vim.log.levels.INFO)
								end
							end)
							return true
						end,
					})
				end
				map('n', '<leader>g#', select_base_commit, { desc = "Select commit as gitsigns base" })

				-- Show changed files against the selected base commit
				local function show_changed_files()
					local base = vim.g.gitsigns_base_commit
					if not base then
						vim.notify("No base commit selected. Use <leader>g# or <leader>gB first.", vim.log.levels.WARN)
						return
					end

					local pickers = require('telescope.pickers')
					local finders = require('telescope.finders')
					local conf = require('telescope.config').values
					local actions = require('telescope.actions')
					local action_state = require('telescope.actions.state')
					local previewers = require('telescope.previewers')

					-- Get list of changed files
					local files = vim.fn.systemlist("git diff --name-only " .. base .. " HEAD")
					if vim.v.shell_error ~= 0 or #files == 0 then
						vim.notify("No changed files against " .. base:sub(1, 7), vim.log.levels.INFO)
						return
					end

					pickers.new({}, {
						prompt_title = "Changed Files (vs " .. base:sub(1, 7) .. ")",
						finder = finders.new_table({ results = files }),
						sorter = conf.generic_sorter({}),
						previewer = previewers.new_termopen_previewer({
							get_command = function(entry)
								return { "git", "diff", base, "HEAD", "--", entry.value }
							end,
						}),
						attach_mappings = function(prompt_bufnr, map_fn)
							actions.select_default:replace(function()
								local selection = action_state.get_selected_entry()
								actions.close(prompt_bufnr)
								if selection then
									vim.cmd("edit " .. selection.value)
								end
							end)
							return true
						end,
					}):find()
				end
				map('n', '<leader>gS', show_changed_files, { desc = "Show changed files vs base" })

				-- Add Lazygit keymapping 
				local Terminal  = require('toggleterm.terminal').Terminal
				local lazygit = Terminal:new({ cmd = "lazygit", hidden = true , direction="float", 
					on_open = function(_)
						vim.cmd "startinsert!"
					end,})

				function _lazygit_toggle()
					lazygit:toggle()
				end

				vim.api.nvim_set_keymap("n", "<leader>gl", "<cmd>lua _lazygit_toggle()<CR>", {noremap = true, silent = true, desc = "Open Lazygit"})

				-- Text object
				map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = "Select git hunk" })
			end
    })
  end,
}
