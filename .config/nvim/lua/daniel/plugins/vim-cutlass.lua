return {
    "svermeulen/vim-cutlass",
	config = function()
        -- Convert 'x' to 'd' in normal mode
        vim.api.nvim_set_keymap('n', 'x', 'd', { noremap = true })

        -- Convert 'x' to 'd' in visual mode
        vim.api.nvim_set_keymap('x', 'x', 'd', { noremap = true })

        -- Convert 'xx' to 'dd' in normal mode
        vim.api.nvim_set_keymap('n', 'xx', 'dd', { noremap = true })

        -- Convert 'X' to 'D' in normal mode
        vim.api.nvim_set_keymap('n', 'X', 'D', { noremap = true })
	end,
}
