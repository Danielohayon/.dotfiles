return {
	"nvim-tree/nvim-tree.lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local nvimtree = require("nvim-tree")
		local api = require("nvim-tree.api")

		-- Track current sort mode (default is name)
		local current_sort = "name"

		-- Track adaptive size mode
		local adaptive_size = false

		local function calculate_tree_width()
			local max_width = 0
			local function traverse(nodes, depth)
				for _, node in ipairs(nodes) do
					-- Calculate display width: indent (2 per level) + icon (2) + name + padding
					local indent = depth * 2
					local icon_width = 3
					local name_len = vim.fn.strwidth(node.name or "")
					local total = indent + icon_width + name_len + 4 -- extra padding
					if total > max_width then
						max_width = total
					end
					-- Recurse into open directories
					if node.open and node.nodes then
						traverse(node.nodes, depth + 1)
					end
				end
			end
			local tree = api.tree.get_nodes()
			if tree and tree.nodes then
				traverse(tree.nodes, 0)
			end
			return math.max(max_width, 30) -- minimum 30
		end

		local function apply_adaptive_width()
			if adaptive_size then
				local width = calculate_tree_width()
				api.tree.resize({ width = width })
			end
		end

		local function toggle_adaptive_width()
			adaptive_size = not adaptive_size
			if adaptive_size then
				local width = calculate_tree_width()
				api.tree.resize({ width = width })
				vim.notify("Tree width: adaptive (" .. width .. ")", vim.log.levels.INFO)
			else
				api.tree.resize({ width = 35 })
				vim.notify("Tree width: fixed (35)", vim.log.levels.INFO)
			end
		end


		-- Diff picker mode state
		local diff_pick_mode = false
		local diff_source_file = nil

		local function toggle_sort()
			if current_sort == "name" then
				current_sort = "modification_time"
				vim.notify("Sorting by: modification time", vim.log.levels.INFO)
			else
				current_sort = "name"
				vim.notify("Sorting by: name", vim.log.levels.INFO)
			end
			require("nvim-tree.api").tree.reload()
		end

		local function on_attach(bufnr)
			local function opts(desc)
				return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
			end

			-- default mappings
			api.config.mappings.default_on_attach(bufnr)

			-- custom mappings: gy for relative, gY for absolute
			vim.keymap.del("n", "gy", { buffer = bufnr })
			vim.keymap.set("n", "gy", api.fs.copy.relative_path, opts("Copy Relative Path"))
			vim.keymap.set("n", "gY", api.fs.copy.absolute_path, opts("Copy Absolute Path"))

			-- toggle sort by modification time
			vim.keymap.set("n", "gm", toggle_sort, opts("Toggle sort (name/modification time)"))

			-- clear all bookmarks
			vim.keymap.set("n", "bc", api.marks.clear, opts("Clear all bookmarks"))

			-- Clear diff pick mode when closing tree with q
			vim.keymap.del("n", "q", { buffer = bufnr })
			vim.keymap.set("n", "q", function()
				if diff_pick_mode then
					diff_pick_mode = false
					diff_source_file = nil
					vim.notify('Diff compare cancelled', vim.log.levels.INFO)
				end
				api.tree.close()
			end, opts("Close"))

			-- Override Enter to handle diff pick mode and adaptive width
			vim.keymap.del("n", "<CR>", { buffer = bufnr })
			vim.keymap.set("n", "<CR>", function()
				local node = api.tree.get_node_under_cursor()
				if node.type == "directory" then
					api.node.open.edit()
					vim.defer_fn(apply_adaptive_width, 10)
					return
				end
				if diff_pick_mode and diff_source_file then
					local target_path = node.absolute_path
					-- Move to window on the right of nvim-tree
					vim.cmd('wincmd l')
					vim.cmd('edit ' .. vim.fn.fnameescape(diff_source_file))
					vim.cmd('vert diffsplit ' .. vim.fn.fnameescape(target_path))
					vim.defer_fn(function()
						vim.notify(
							']c/[c: next/prev change | do: obtain | dp: put | <leader>q to exit',
							vim.log.levels.INFO
						)
					end, 100)
					diff_pick_mode = false
					diff_source_file = nil
				else
					api.node.open.edit()
				end
			end, opts("Open / Diff compare"))

			-- Override o to also trigger adaptive width
			vim.keymap.del("n", "o", { buffer = bufnr })
			vim.keymap.set("n", "o", function()
				api.node.open.edit()
				vim.defer_fn(apply_adaptive_width, 10)
			end, opts("Open"))

			-- Override backspace (close directory) to trigger adaptive width
			vim.keymap.del("n", "<BS>", { buffer = bufnr })
			vim.keymap.set("n", "<BS>", function()
				api.node.navigate.parent_close()
				vim.defer_fn(apply_adaptive_width, 10)
			end, opts("Close Directory"))

			-- Override W (collapse all) to trigger adaptive width
			vim.keymap.del("n", "W", { buffer = bufnr })
			vim.keymap.set("n", "W", function()
				api.tree.collapse_all()
				vim.defer_fn(apply_adaptive_width, 10)
			end, opts("Collapse All"))

			-- Override E (expand all) to trigger adaptive width
			vim.keymap.del("n", "E", { buffer = bufnr })
			vim.keymap.set("n", "E", function()
				api.tree.expand_all()
				vim.defer_fn(apply_adaptive_width, 10)
			end, opts("Expand All"))
		end

		-- recommended settings from nvim-tree documentation
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		-- change color for arrows in tree to light blue
		vim.cmd([[ highlight NvimTreeFolderArrowClosed guifg=#3FC5FF ]])
		vim.cmd([[ highlight NvimTreeFolderArrowOpen guifg=#3FC5FF ]])

		-- configure nvim-tree
		nvimtree.setup({
			on_attach = on_attach,
			bookmarks = {
				persist = true, -- save bookmarks across sessions
			},
			sort = {
				sorter = function(nodes)
					if current_sort == "modification_time" then
						table.sort(nodes, function(a, b)
							-- Folders first, then sort by modification time (newest first)
							if a.type ~= b.type then
								return a.type == "directory"
							end
							return (a.fs_stat and a.fs_stat.mtime.sec or 0) > (b.fs_stat and b.fs_stat.mtime.sec or 0)
						end)
					else
						table.sort(nodes, function(a, b)
							-- Folders first, then sort by name
							if a.type ~= b.type then
								return a.type == "directory"
							end
							return a.name:lower() < b.name:lower()
						end)
					end
				end,
			},
			view = {
				width = 35,
				relativenumber = false,
			},
			update_focused_file = {
				enable = true,
			},
			-- change folder arrow icons
			renderer = {
				indent_markers = {
					enable = true,
				},
				icons = {
					glyphs = {
						folder = {
							-- arrow_closed = "", -- arrow when folder is closed
							-- arrow_open = "", -- arrow when folder is open
						},
					},
				},
			},
			-- open_file = {
			-- },
			-- disable window_picker for
			-- explorer to work well with
			-- window splits
			actions = {
				open_file = {
					window_picker = {
						enable = true,
						picker = "default",
						chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
						exclude = {
							filetype = { "notify", "lazy", "qf", "diff", "fugitive", "fugitiveblame" },
							buftype = { "nofile", "terminal", "help" },
						},
					},
				},
			},
			filters = {
                -- dotfiles = false,
				custom = { ".DS_Store" },
			},
			git = {
				ignore = false,
				timeout = 5000, -- increase timeout for large repos (default 400ms)
			},
			filesystem_watchers = {
				enable = true,
				debounce_delay = 50,
				ignore_dirs = { "node_modules", ".git", "venv", ".venv" },
			},
		})

		-- set keymaps
		local keymap = vim.keymap -- for conciseness
		keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
		keymap.set("n", "<leader>w", toggle_adaptive_width, { desc = "Toggle tree adaptive width" })
		keymap.set("n", "<leader>p", "<cmd>NvimTreeFocus<CR>", { desc = "Focus file explorer" })
		-- keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer on current file" }) -- toggle file explorer on current file
		-- keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" }) -- collapse file explorer
		keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" }) -- refresh file explorer
		keymap.set("n", "t", api.node.open.tab, { desc = "Open in new tab" }) -- refresh file explorer

		-- Diff compare using nvim-tree picker
		keymap.set("n", "<leader>lC", function()
			local current_file = vim.fn.expand('%:p')
			if current_file == '' then
				vim.notify('No file in current buffer', vim.log.levels.WARN)
				return
			end
			diff_pick_mode = true
			diff_source_file = current_file
			vim.notify('Select file to compare with (Enter to select, q to cancel)', vim.log.levels.INFO)
			api.tree.open()
		end, { desc = "Compare file with another (diff via tree)" })

	end,
}

-- usful keybinds to remember
--   vim.keymap.set('n', '<Tab>',api.node.open.preview,('Open Preview'))
