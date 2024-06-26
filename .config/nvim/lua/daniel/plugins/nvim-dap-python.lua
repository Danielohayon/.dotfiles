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
			",",
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
			";",
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
				require("dap").continue({ config = { justMyCode = false }})
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
		{ "<leader>dls", function() require'telescope'.extensions.dap.frames{} end, desc = "List Stack Frames", ft = "python",},
		{ "<leader>dlb", function() require'telescope'.extensions.dap.list_breakpoints{} end, desc = "List Breakpoints", ft = "python",},
		{ "<leader>dlc", function() require'telescope'.extensions.dap.commands{} end, desc = "List Debugging Commands", ft = "python",},
		{ "<leader>dlv", function() require'telescope'.extensions.dap.variables{} end, desc = "List Variables", ft = "python",},
	},
	config = function()
		local path = require("mason-registry").get_package("debugpy"):get_install_path()
		require("dap-python").setup(path .. "/venv/bin/python")
        table.insert(require('dap').configurations.python,{
                type = 'python';
                justMyCode = false;
                request = 'attach';
                name = 'Attach remote not justMyCode';
                connect = function()
                    local host = vim.fn.input('Host [127.0.0.1]: ')
                    host = host ~= '' and host or '127.0.0.1'
                    local port = tonumber(vim.fn.input('Port [5678]: ')) or 5678
                    return { host = host, port = port }
                end;
        })



        -- table.insert(require('dap').configurations.python, {
        --     justMyCode = false,
        --     type = 'python',
        -- })


        -- require('telescope').setup()
        -- require('telescope').load_extension('dap')
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
