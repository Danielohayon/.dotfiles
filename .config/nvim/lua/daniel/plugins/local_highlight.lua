return {
	'tzachar/local-highlight.nvim',
	config = function()
		require('local-highlight').setup({
			file_types = {'python', 'cpp', 'lua', 'c', 'sh', 'bash', 'json'},
			hlgroup = 'Search',
			animate = false,  -- disable animation to suppress snacks.nvim warning
		})
		vim.opt.updatetime = 700
	end,
}
