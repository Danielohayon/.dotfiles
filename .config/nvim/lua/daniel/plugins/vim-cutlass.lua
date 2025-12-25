return {
    "svermeulen/vim-cutlass",
	config = function()
        -- Convert 'x' to 'd' in normal mode
        vim.api.nvim_set_keymap('n', 'x', 'd', { noremap = true, silent = true, desc = "Cut (motion)" })

        -- Convert 'x' to 'd' in visual mode
        vim.api.nvim_set_keymap('x', 'x', 'd', { noremap = true, silent = true, desc = "Cut selection" })

        -- Convert 'xx' to 'dd' in normal mode
        vim.api.nvim_set_keymap('n', 'xx', 'dd', { noremap = true, silent = true, desc = "Cut line" })

        -- Convert 'X' to 'D' in normal mode
        vim.api.nvim_set_keymap('n', 'X', 'D', { noremap = true, silent = true, desc = "Cut to end of line" })
	end,
}
