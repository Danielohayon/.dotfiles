# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository containing shell, tmux, and Neovim configurations primarily designed for Linux development environments with kubectl/Kubernetes workflows.

## Setup

Run `Setup.sh` to install dependencies and link configuration files:
- Installs Neovim, ripgrep, fzf, fd-find, npm, pyright
- Links nvim config to `~/.config/nvim`
- Links tmux config to `~/.tmux.conf`

For manual symlinks:
```bash
ln -sf ~/.dotfiles/.tmux.conf ~/.tmux.conf
ln -s ~/.dotfiles/.config/nvim ~/.config/nvim
```

## Structure

- `.bashrc` - Shell configuration with zoxide (`cd` aliased to `z`), fzf, kubectl shortcuts
- `.bash_aliases` - Aliases: `lz` (lazygit), `v` (nvim), `ll/ls/la` (exa), various AI chat aliases
- `.tmux.conf` - Tmux with `C-f` prefix, vim-style navigation, catppuccin theme, TPM plugins
- `.config/nvim/` - Neovim config using lazy.nvim plugin manager

## Neovim Config

Leader key is `<Space>`. Config structure:
- `lua/daniel/lazy.lua` - Plugin manager setup
- `lua/daniel/core/` - Core settings and keymaps
- `lua/daniel/plugins/` - Individual plugin configurations

Key plugins: telescope, nvim-tree, harpoon, treesitter, LSP (mason), nvim-cmp, gitsigns

## Key Bindings Reference

### Tmux (prefix: C-f)
- `h/l` - Previous/next window
- `C-p/C-n/C-g` - Previous/next/new window (no prefix)
- `\ / -` - Split vertical/horizontal

### Neovim
- `jk/kj` - Exit insert mode
- `H/L` - Move 6 lines up/down
- `<leader>w/q/x` - Save/quit/quit all
- `mw/mq/mx` - Next/prev/close buffer
- `<leader>sv/sh` - Split vertical/horizontal
