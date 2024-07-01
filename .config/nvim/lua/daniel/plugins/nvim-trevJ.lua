return {
	"AckslD/nvim-trevJ.lua",

    event = { "BufReadPre", "BufNewFile" },
	config = function()
		-- uncomment if you want to lazy load
		-- module = 'trevj',

		local trevj = require("trevj")
		-- an example for configuring a keybind, can also be done by filetype
		trevj.setup()

		local keymap = vim.keymap -- for conciseness

		keymap.set("n", "<leader>lj", "<cmd>lua require(\"trevj\").format_at_cursor()<CR>", { desc = "Format json at cursor" }) -- toggle file explorer
	end,
}
