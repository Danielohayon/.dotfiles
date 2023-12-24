vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct
require("daniel/lazy")
require("daniel.core")
vim.cmd("NvimTreeOpen")
