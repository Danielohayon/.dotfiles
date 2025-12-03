local keymap = vim.keymap -- for conciseness


-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- clear search highlights
keymap.set("n", "<leader>lh", ":nohl<CR>", { desc = "Clear search highlights" })

-- delete single character without copying into register
-- keymap.set("n", "x", '"_x')
-- increment/decrement numbers
-- keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
-- keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window
keymap.set("n", "<leader>li2", "<cmd>set autoindent expandtab tabstop=2 shiftwidth=2<CR>", { desc = "Change indentation level to 2" }) -- close current split window

-- keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
-- keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
-- keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
-- keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
-- keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab


vim.api.nvim_set_keymap('n', 'L', '6j', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', 'H', '6k', {noremap = true, silent = true})
vim.api.nvim_set_keymap('v', 'L', '6j', {noremap = true, silent = true})
vim.api.nvim_set_keymap('v', 'H', '6k', {noremap = true, silent = true})




local opts = { noremap = true, silent = true }

opts.desc = ":q"
keymap.set("n", "<leader>q", ":q<CR>", opts)

opts.desc = ":qa"
keymap.set("n", "<leader>x", ":qa<CR>", opts)

opts.desc = ":w"
keymap.set("n", "<leader>w", ":w<CR>", opts)

-- Navigate buffers
opts.desc = "Next Tab"
keymap.set("n", "mw", ":bnext<CR>", opts)

opts.desc = "Previous Tab"
keymap.set("n", "mq", ":bprevious<CR>", opts)

opts.desc = "Close Tab"
keymap.set("n", "mx", ":<C-U>bp <bar> bd #<CR>", opts)


-- Resize Panes
keymap.set("n", "<S-Down>", ":resize -2<CR>", opts)
keymap.set("n", "<S-Up>", ":resize +2<CR>", opts)
keymap.set("n", "<S-Right>", ":vertical resize -2<CR>", opts)
keymap.set("n", "<S-Left>", ":vertical resize +2<CR>", opts)

-- Insert --
-- Press jk fast to exit insert mode 
keymap.set("i", "jk", "<ESC>", opts)
keymap.set("i", "kj", "<ESC>", opts)

-- Move text up and down
keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)
keymap.set("v", "p", '"_dP', opts)
-- Move text up and down
keymap.set("n", "<A-j>", ":m .+1<CR>==", opts)
keymap.set("n", "<A-k>", ":m .-2<CR>==", opts)

opts.desc = "Toggle Wrap"
keymap.set("n", "<leader>lw", ":set invwrap<CR>", opts)

-- Control Virtual Text
vim.diagnostic.config({ 
	virtual_text = false, -- Frist set it to false by default 
})

local virtual_text_visible = false
function ToggleVirtualText()
    virtual_text_visible = not virtual_text_visible
    vim.diagnostic.config({
        virtual_text = virtual_text_visible,
    })
end

vim.api.nvim_set_keymap('n', '<leader>lt', ':lua ToggleVirtualText()<CR>', { noremap = true, silent = true })

