# Passive & Appearance Plugins

Plugins that apply automatically (colorscheme, statusline, visual helpers) or require at most a toggle. No complex modes or workflows.

---

## nightfox.nvim — Colorscheme

**What:** Dark colorscheme with a Nord-inspired palette. Applied on startup via `vim.cmd("colorscheme nordfox")`.

**Variant:** `nordfox` (other variants available: `carbonfox`, `dawnfox`, `dayfox`, `duskfox`, `nightfox`, `terafox`).

---

## lualine.nvim — Statusline

**What:** Configurable statusline. Shows current mode, filename, git branch, LSP diagnostics, file type, cursor position, and more in a colorful bottom bar.

---

## which-key.nvim — Keybinding Popup

**What:** Displays a popup of available keybindings when you pause after pressing `<leader>` or any partial key sequence. Completely automatic — no intentional interaction needed. Timeout is set to 300ms.

---

## indent-blankline.nvim — Indentation Guides

**What:** Draws thin vertical lines at each indentation level, even on blank lines. Helps visually track nesting depth.

---

## nvim-numbertoggle — Line Number Mode

**What:** Automatically switches between relative line numbers (normal mode) and absolute line numbers (insert mode, or when a window loses focus).

---

## vim-sleuth — Auto Indent Detection

**What:** Detects and applies consistent `tabstop`, `shiftwidth`, and `expandtab` settings on a per-buffer basis by analyzing the file's existing indentation style. No configuration needed.

---

## gitsigns.nvim — Git Gutter Signs

**What:** Shows `+`, `~`, `_` signs in the sign column for lines added, changed, or deleted relative to the git index/HEAD. Also shows hunk status on the far-left sign column.

**Interaction:** Purely visual in this config. The gutter signs appear automatically. The plugin also provides commands (e.g., `:Gitsigns next_hunk`, `:Gitsigns stage_hunk`) accessible via `:` command line, but no keybindings are configured for them.

---

## Highlight on Yank

**What:** Briefly flashes the yanked text. Configured via a `TextYankPost` autocommand in `init.lua` (line 32–36).

**Keybinding:** N/A — works automatically when you yank anything with `y`, `yy`, `Y`, etc.
