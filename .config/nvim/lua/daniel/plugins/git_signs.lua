return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  -- config = true,
  config = function()
    -- import comment plugin safely
    local gitsigns = require("gitsigns")
    gitsigns.setup({
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
				end, {expr=true})

				map('n', '[c', function()
					if vim.wo.diff then return '[c' end
					vim.schedule(function() gs.prev_hunk() end)
					return '<Ignore>'
				end, {expr=true})

				-- Actions
				map('n', '<leader>ghs', gs.stage_hunk, { desc = "Stage Hunk" })
				map('n', '<leader>ghr', gs.reset_hunk, { desc = "Reset Hunk" })
				map('v', '<leader>ghs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = "Stage Hunk" })
				map('v', '<leader>ghr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = "Reset Hunk" })
				map('n', '<leader>ga', gs.stage_buffer, { desc = "Stage Buffer" })
				map('n', '<leader>ghu', gs.undo_stage_hunk, {desc = "Undo Stage Hunk" })
				map('n', '<leader>gR', gs.reset_buffer, {desc = "Reset Buffer" })
				map('n', '<leader>ghp', gs.preview_hunk, {desc = "Preview Hunk" })
				map('n', '<leader>gb', function() gs.blame_line{full=true} end, { desc = "Blame Line" })
				map('n', '<leader>gtb', gs.toggle_current_line_blame, {desc = "Toggle Current Line Blame" })
				map('n', '<leader>gd', gs.diffthis, {desc = "Diff File" })
				map('n', '<leader>gD', function() gs.diffthis('~') end, {desc = "Diff File ~" })
				map('n', '<leader>gtd', gs.toggle_deleted, { desc = "Toggle Deleted" })

				-- Telescope Functions 

				map('n', '<leader>gc', "<cmd>Telescope git_bcommits<cr>", { desc = "Toggle Deleted" })
				map('n', '<leader>gs', "<cmd>Telescope git_status<cr>", { desc = "Toggle Deleted" })


				-- Add Lazygit keymapping 
				local Terminal  = require('toggleterm.terminal').Terminal
				local lazygit = Terminal:new({ cmd = "lazygit", hidden = true , direction="float", 
					on_open = function(_)
						vim.cmd "startinsert!"
					end,})

				function _lazygit_toggle()
					lazygit:toggle()
				end

				vim.api.nvim_set_keymap("n", "<leader>gl", "<cmd>lua _lazygit_toggle()<CR>", {noremap = true, silent = true})

				-- Text object
				map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
			end
    })
  end,
}
