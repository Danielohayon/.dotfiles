# Neovim Configuration

Leader key: `<Space>`

## Plugins & Keymaps

### Core Navigation

| Key | Action |
|-----|--------|
| `jk` / `kj` | Exit insert mode |
| `H` | Move 6 lines up (visual lines) |
| `L` | Move 6 lines down (visual lines) |
| `j` / `k` | Move by visual lines when wrapped |
| `<` / `>` | Indent and keep selection (visual) |
| `<A-j>` / `<A-k>` | Move line/selection up/down |

### Window & Buffer Management

| Key | Action |
|-----|--------|
| `<leader>w` | Save file |
| `<leader>q` | Quit |
| `<leader>x` | Quit all |
| `<leader>sv` | Split vertical |
| `<leader>sh` | Split horizontal |
| `<leader>se` | Make splits equal |
| `<leader>sx` | Close split |
| `mw` | Next buffer |
| `mq` | Previous buffer |
| `mx` | Close buffer |
| `<S-Arrow>` | Resize panes |

### File Explorer (nvim-tree)

| Key | Action |
|-----|--------|
| `<leader>e` | Toggle file explorer |
| `<leader>p` | Focus file explorer |
| `t` | Open in new tab (in tree) |

### Telescope (Fuzzy Finder)

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fF` | Find files (include hidden) |
| `<leader>fo` | Recent files |
| `<leader>fs` | Live grep (with args) |
| `<leader>fS` | Live grep with context preview |
| `<leader>fu` | Grep string under cursor |
| `<leader>fU` | Grep under cursor with context |
| `<leader>fh` | Search in current buffer |
| `<leader>fr` | Resume previous search |
| `<leader>fp` | Previous searches |
| `<leader>fy` | Clipboard history (neoclip) |
| `<leader>fd` | Live grep in directory |
| `<leader>fv` | Command history |
| `<leader>fj` | Jump list |
| `<leader>fk` | Keymaps |

**Live Grep Args (in search mode):**
| Key | Action |
|-----|--------|
| `<C-r>` | Add glob filter (`-g`) |
| `<C-t>` | Add type filter (`-t`) |
| `<C-space>` | Fuzzy refine results |

### Bookmarks (tomasky/bookmarks.nvim)

| Key | Action |
|-----|--------|
| `mm` | Toggle bookmark |
| `ma` | Add/edit annotation |
| `mc` | Clean bookmarks in buffer |
| `mC` | Clear all bookmarks |
| `ml` | List bookmarks (telescope) |

**Annotation keywords:** `@t` (todo), `@w` (warning), `@n` (note), `@q` (question)

### Pdbrc Breakpoints (for remote debugging with pdb/pdbpp)

| Key | Action |
|-----|--------|
| `<leader>pb` | Toggle breakpoint (writes to .pdbrc) |
| `<leader>pB` | Clear file breakpoints |
| `<leader>pX` | Clear all breakpoints |
| `<leader>pl` | List all breakpoints |

### Harpoon (Quick File Navigation)

| Key | Action |
|-----|--------|
| `<leader>mm` | Mark file |
| `<leader>mv` | Quick menu |
| `<leader>mc` | Telescope marks |
| `<leader>mj` | Previous file |
| `<leader>mk` | Next file |
| `<leader>ma-mh` | Jump to file 1-6 |

### LSP

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Show references |
| `gt` | Go to type definition |
| `gi` | Incoming calls |
| `go` | Outgoing calls |
| `K` | Hover documentation |
| `<leader>la` | Code actions |
| `<leader>lr` | Rename symbol |
| `<leader>ld` | Line diagnostics |
| `<leader>lD` | Buffer diagnostics |
| `<leader>ln` | Next diagnostic |
| `<leader>lp` | Previous diagnostic |
| `<leader>lf` | Format file/selection |
| `<leader>lx` | Restart LSP |
| `<leader>ls` | Spell suggest |
| `<leader>lt` | Toggle virtual text |
| `<leader>lh` | Clear search highlights |
| `<leader>lw` | Toggle word wrap |
| `<leader>li2` | Set indent to 2 spaces |

### Git (gitsigns + lazygit)

| Key | Action |
|-----|--------|
| `]c` / `[c` | Next/prev hunk |
| `<leader>ghs` | Stage hunk |
| `<leader>ghr` | Reset hunk |
| `<leader>ga` | Stage buffer |
| `<leader>ghu` | Undo stage hunk |
| `<leader>gR` | Reset buffer |
| `<leader>ghp` | Preview hunk |
| `<leader>gb` | Blame line |
| `<leader>gtb` | Toggle line blame |
| `<leader>gd` | Diff file (vscode style) |
| `<leader>gD` | Diff file vs HEAD |
| `<leader>gtd` | Toggle deleted |
| `<leader>gc` | Git commits |
| `<leader>gs` | Git status |
| `<leader>gl` | Lazygit |

### Debugging (DAP - Python)

| Key | Action |
|-----|--------|
| `<leader>db` | Toggle breakpoint |
| `<leader>dc` | Continue |
| `<leader>dn` / `,` | Step over |
| `<leader>ds` / `;` | Step into |
| `<leader>du` | Step out |
| `<leader>dz` | Step back |
| `<leader>dh` | Run to cursor |
| `<leader>dp` | Pause |
| `<leader>dq` | Quit debugging |
| `<leader>dd` | Disconnect |
| `<leader>dt` | Toggle debug UI |
| `<leader>de` | Evaluate expression |
| `<leader>dPt` | Debug test method |
| `<leader>dPc` | Debug test class |
| `<leader>dls` | List stack frames |
| `<leader>dlb` | List breakpoints |
| `<leader>dlc` | List debug commands |
| `<leader>dlv` | List variables |

### Terminal (toggleterm)

| Key | Action |
|-----|--------|
| `<leader>tt` | Toggle terminal |
| `<leader>tf` | Toggle float terminal |
| `<leader>ts` | Send line/selection to terminal |
| `<Esc>` / `jk` | Exit terminal insert mode |
| `<C-h/j/k/l>` | Navigate from terminal |

### Motion & Editing

#### Leap (Quick Jump)
| Key | Action |
|-----|--------|
| `s` | Leap forward |
| `S` | Leap backward |
| `gs` | Leap to other windows |

#### Surround (nvim-surround)
| Key | Action |
|-----|--------|
| `ys{motion}{char}` | Add surround |
| `ds{char}` | Delete surround |
| `cs{old}{new}` | Change surround |

#### Comment (Comment.nvim)
| Key | Action |
|-----|--------|
| `gcc` | Toggle line comment |
| `gbc` | Toggle block comment |
| `gc{motion}` | Comment motion |

### Treesitter

| Key | Action |
|-----|--------|
| `<C-space>` | Init/increment selection |
| `<BS>` | Decrement selection |
| `]f` / `[f` | Next/prev function |
| `]c` / `[c` | Next/prev class |
| `<leader>tc` | Toggle treesitter context |

### Code Navigation

#### Aerial (Code Outline)
| Key | Action |
|-----|--------|
| `<leader>co` | Toggle code outline |
| `<leader>cn` | Next symbol |
| `<leader>cp` | Previous symbol |

### Other

| Key | Action |
|-----|--------|
| `<leader>z` | Zoom current window (NeoZoom) |

### Completion (nvim-cmp)

| Key | Action |
|-----|--------|
| `<C-j>` / `<Tab>` | Next suggestion |
| `<C-k>` | Previous suggestion |
| `<C-Space>` | Show completions |
| `<C-e>` | Close completions |
| `<CR>` | Confirm selection |
| `<C-b>` / `<C-f>` | Scroll docs |

### Clipboard (neoclip)

| Key | Action |
|-----|--------|
| `<leader>fy` | Open clipboard history |
| `<CR>` | Paste behind |
| `<C-w>` | Paste |
| `<C-d>` | Delete entry |
| `<C-e>` | Edit entry |

---

## Installed Plugins

### UI & Theme
- **catppuccin/nvim** - Color scheme
- **akinsho/bufferline.nvim** - Buffer tabs
- **nvim-lualine/lualine.nvim** - Status line
- **nvim-tree/nvim-tree.lua** - File explorer
- **folke/which-key.nvim** - Keymap hints
- **lukas-reineke/indent-blankline.nvim** - Indent guides
- **stevearc/dressing.nvim** - Better UI for inputs
- **nyngwang/NeoZoom.lua** - Window zoom

### Navigation & Search
- **nvim-telescope/telescope.nvim** - Fuzzy finder
- **nvim-telescope/telescope-fzf-native.nvim** - FZF sorter
- **nvim-telescope/telescope-live-grep-args.nvim** - Grep with args
- **princejoogie/dir-telescope.nvim** - Directory scoped search
- **ThePrimeagen/harpoon** - Quick file marks
- **ggandor/leap.nvim** - Quick motion
- **tomasky/bookmarks.nvim** - Code bookmarks
- **stevearc/aerial.nvim** - Code outline

### LSP & Completion
- **neovim/nvim-lspconfig** - LSP configuration
- **williamboman/mason.nvim** - LSP installer
- **hrsh7th/nvim-cmp** - Autocompletion
- **L3MON4D3/LuaSnip** - Snippets
- **rafamadriz/friendly-snippets** - Snippet collection

### Git
- **lewis6991/gitsigns.nvim** - Git signs & hunks
- **esmuellert/vscode-diff.nvim** - VSCode-style diff

### Debugging
- **mfussenegger/nvim-dap** - Debug adapter
- **rcarriga/nvim-dap-ui** - Debug UI
- **mfussenegger/nvim-dap-python** - Python debugging

### Treesitter
- **nvim-treesitter/nvim-treesitter** - Syntax highlighting
- **nvim-treesitter/nvim-treesitter-context** - Sticky context
- **nvim-treesitter/nvim-treesitter-textobjects** - Text objects

### Editing
- **numToStr/Comment.nvim** - Commenting
- **kylechui/nvim-surround** - Surround actions
- **gbprod/cutlass.nvim** - Better cut/delete
- **Wansmer/treesj** - Split/join blocks
- **AckslD/nvim-neoclip.lua** - Clipboard manager

### Terminal & Integration
- **akinsho/toggleterm.nvim** - Terminal toggle
- **christoomey/vim-tmux-navigator** - Tmux integration

### Formatting & Linting
- **stevearc/conform.nvim** - Formatter
- **mfussenegger/nvim-lint** - Linter

### Other
- **stevearc/oil.nvim** - Edit filesystem like buffer
- **nvim-lua/plenary.nvim** - Lua utilities
- **nvim-tree/nvim-web-devicons** - Icons
- **pdbrc-breakpoints** (custom) - Toggle breakpoints to .pdbrc for pdb/pdbpp
