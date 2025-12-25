return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			local opts = { noremap = true, silent = true }
			local keymap = vim.keymap -- for conciseness
			local toggleterm = require("toggleterm")
			toggleterm.setup({
				-- open_mapping = "<leader>tt", -- default key mapping to open the terminal
				shade_terminals = true,
				shading_factor = 2,
				start_in_insert = true,
			})

			-- keymap.set("n", "<leader>t",
			-- keymap.set("n", "<F12>", ":ToggleTerm<CR>", { noremap = true, silent = true })
			-- keymap.set("t", "<F12>", "<C-\\><C-n>:ToggleTerm<CR>", { noremap = true, silent = true })
			opts.desc = "Toggle Terminal"
			keymap.set("n", "<leader>tt", ":ToggleTerm<CR>", opts)

            opts.desc = "Exit insert mode in terminal"
			keymap.set("t", "<Esc>", "<C-\\><C-n>", opts)

			opts.desc = "Send current line to terminal"
			keymap.set("n", "<leader>ts", ":ToggleTermSendCurrentLine <T_ID><CR>", opts)


			opts.desc = "Send visual selection to terminal"
			keymap.set("v", "<leader>ts", ":ToggleTermSendVisualLines <T_ID><CR>", opts)

            vim.api.nvim_set_keymap('n', '<leader>tf', ':lua set_terminal_mode_float()<CR>:ToggleTerm<CR>', {noremap = true, silent = true, desc = "Toggle Terminal (float)"})

			vim.keymap.set("t", "jk", [[<C-\><C-n>]], { noremap = true, silent = true, desc = "Exit terminal mode" })
			vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], { noremap = true, silent = true, desc = "Window left" })
			vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], { noremap = true, silent = true, desc = "Window down" })
			vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR> <Cmd>wincmd l<CR>]], { noremap = true, silent = true, desc = "Window up" })
			vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], { noremap = true, silent = true, desc = "Window right" })
			-- vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
		end,
	},
}
