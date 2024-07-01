return {
	"ggandor/leap.nvim",
	enabled = true,
	keys = {
		{ "s", mode = { "n", "x", "o" }, desc = "Leap Forward to" },
		{ "S", mode = { "n", "x", "o" }, desc = "Leap Backward to" },
		{ "gs", mode = { "n", "x", "o" }, desc = "Leap from Windows" },
	},
	config = function(_, opts)
		local leap = require("leap")
		for k, v in pairs(opts) do
			leap.opts[k] = v
		end
        leap.opts.equivalence_classes = { ' \t\r\n', '([{', ')]}', '\'"`' }
        leap.opts.special_keys.prev_target = '<backspace>'
        leap.opts.special_keys.prev_group = '<backspace>'
        require('leap.user').set_repeat_keys('<enter>', '<backspace>')
		leap.add_default_mappings(true)
		vim.keymap.del({ "x", "o" }, "x")
		vim.keymap.del({ "x", "o" }, "X")
	end,
}
