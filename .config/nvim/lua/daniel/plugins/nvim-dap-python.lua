return {
	"mfussenegger/nvim-dap-python",
	dependencies = { "mfussenegger/nvim-dap" },
	ft = "python",
	keys = {
		{
			"<leader>dPt",
			function()
				require("dap-python").test_method()
			end,
			desc = "Debug Method",
			ft = "python",
		},
		{
			"<leader>dPc",
			function()
				require("dap-python").test_class()
			end,
			desc = "Debug Class",
			ft = "python",
		},
		{
			"<leader>db",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "Toggle Breakpoint",
			ft = "python",
		},
		{
			"<leader>dn",
			function()
				require("dap").step_over()
			end,
			desc = "Step Over",
			ft = "python",
		},
		{
			"n",
			function()
				require("dap").step_over()
			end,
			desc = "Step Over",
			ft = "python",
		},
		{
			"<leader>ds",
			function()
				require("dap").step_into()
			end,
			desc = "Step Into",
			ft = "python",
		},
		{
			"N",
			function()
				require("dap").step_into()
			end,
			desc = "Step Into",
			ft = "python",
		},
		{
			"<leader>dh",
			function()
				require("dap").hover()
			end,
			desc = "Hover",
			ft = "python",
		},
		{
			"<leader>dc",
			function()
				require("dap").continue()
			end,
			desc = "Continue",
			ft = "python",
		},
		{
			"<leader>du",
			function()
				require("dap").step_out()
			end,
			desc = "Step Out(up)",
			ft = "python",
		},
		{
			"<leader>dz",
			function()
				require("dap").step_back()
			end,
			desc = "Step Back",
			ft = "python",
		},
		{
			"<leader>dh",
			function()
				require("dap").run_to_cursor()
			end,
			desc = "Run To Cursor (Here)",
			ft = "python",
		},
		{
			"<leader>dq",
			function()
				require("dap").close()
			end,
			desc = "Quit Debugging",
			ft = "python",
		},
		{
			"<leader>dp",
			function()
				require("dap").pause()
			end,
			desc = "Pause",
			ft = "python",
		},
		{
			"<leader>dd",
			function()
				require("dap").disconnect()
			end,
			desc = "Disconnect",
			ft = "python",
		},
		{
			"<leader>ds",
			function()
				require("dap").session()
			end,
			desc = "Get Session",
			ft = "python",
		},
	},
	config = function()
		local path = require("mason-registry").get_package("debugpy"):get_install_path()
		require("dap-python").setup(path .. "/venv/bin/python")
		-- require("dap-python").setup("~/Local/venvs/torch_venv/bin/python")
		-- vim.keymap.set("n", "<Leader>db", function()
		-- 	require("dap").toggle_breakpoint()
		-- end)
		-- vim.keymap.set({ "n", "v" }, "<Leader>dh", function()
		-- 	require("dap.ui.widgets").hover()
		-- end)
		-- vim.keymap.set({ "n", "v" }, "<Leader>dp", function()
		-- 	require("dap.ui.widgets").preview()
		-- end)
		-- vim.keymap.set("n", "<Leader>df", function()
		-- 	local widgets = require("dap.ui.widgets")
		-- 	widgets.centered_float(widgets.frames)
		-- end)
		-- vim.keymap.set("n", "<Leader>ds", function()
		-- 	local widgets = require("dap.ui.widgets")
		-- 	widgets.centered_float(widgets.scopes)
		-- end)
	end,
}
