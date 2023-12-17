return {
	'tzachar/local-highlight.nvim',
	config = function()
		require('local-highlight').setup({
			file_types = {'python', 'cpp', 'lua', 'c', 'sh', 'bash', 'json'}, -- If this is given only attach to this
			hlgroup = 'Search',
		})
	end,
}
