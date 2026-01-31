# AGENTS.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Overview

Personal Neovim configuration using [lazy.nvim](https://github.com/folke/lazy.nvim) as the plugin manager. The config uses Space as the leader key.

## Structure

- `init.lua` - Entry point with base Vim options, leader key setup, and custom keymaps
- `lua/config/lazy.lua` - lazy.nvim bootstrap and setup
- `lua/plugins/` - Plugin specifications (one per file, auto-loaded by lazy.nvim)

## Key Architecture Decisions

### LSP Setup
LSP is managed through a chain: **Mason → mason-lspconfig → nvim-lspconfig**
- Mason installs LSP servers (`lua_ls`, `pyright`, `ts_ls` are auto-installed)
- Server configs are defined in `lua/plugins/lspconfig.lua` under `opts.servers`
- Custom `on_attach` functions can be added per-server (see `clangd` example for C files)

### Completion
Uses nvim-cmp with sources: LSP, LuaSnip snippets, buffer, and path completions.

### AI Integration
- `minuet-ai.nvim` - Inline AI suggestions using Claude (requires `ANTHROPIC_API_KEY` env var)
  - `<C-y>` accept, `<C-l>` accept line, `<C-n>`/`<C-p>` cycle, `<C-e>` dismiss

## Notable Custom Keymaps

| Key | Mode | Action |
|-----|------|--------|
| `<C-\`>` | n | Toggle terminal split (opens new or focuses existing) |
| `<Esc>` | t | Exit terminal mode |
| `<leader>e` | n | Reveal file in Neo-tree |
| `<Tab>/<S-Tab>` | n | Cycle buffers |
| `gd/gr/gi` | n | Go to definition/references/implementations (via Telescope) |
| `<leader>ff` | n | Find files (includes hidden) |
| `<leader>fg` | n | Live grep |
| `<leader>ci` | n | Go to C implementation (in .h files, jumps to .c) |

## Adding New Plugins

Create a new file in `lua/plugins/` returning a lazy.nvim plugin spec table. Example:
```lua
return {
  "author/plugin-name",
  config = function()
    -- setup
  end,
}
```

## Adding New LSP Servers

1. Add server name to `ensure_installed` in `lua/plugins/mason-lspconfig.lua`
2. Add server config in `lua/plugins/lspconfig.lua` under `opts.servers`
