# Navigation & File Finders

Plugins for moving between files, windows, and code structures.

---

## vim-tmux-navigator — Seamless Tmux/Neovim Navigation

**What:** `<C-h/j/k/l>` moves between Neovim splits and tmux panes transparently. If you're at a Neovim window boundary, it moves to the adjacent tmux pane instead. Works in both normal and insert modes (via a brief escape).

### Keybindings

| Key | Action |
|-----|--------|
| `<C-h>` | Move left (split or tmux pane) |
| `<C-j>` | Move down |
| `<C-k>` | Move up |
| `<C-l>` | Move right |

---

## nvim-tree.lua — File Tree

**What:** Sidebar file explorer. Replaces the built-in `netrw`.

### Keybindings

| Key | Mode | Action |
|-----|------|--------|
| `<C-b>` | n, i | Toggle file tree |
| `<leader>b` | n | Focus file tree (move cursor into it) |

### Inside the Tree

Standard nvim-tree bindings apply:
- `?` — toggle help
- `<cr>` / `o` — open file/directory
- `a` — create file/directory
- `d` — delete
- `r` — rename
- `R` — refresh
- `H` — toggle hidden files
- `I` — toggle gitignore

---

## telescope.nvim — Fuzzy Finder

**What:** Fuzzy search over files, buffers, git files, help tags, diagnostics, and more. The primary workflow engine for finding anything.

### Keybindings

| Key | Action |
|-----|--------|
| `<leader>sf` | Search files (includes hidden/dotfiles) |
| `<leader>sg` | Live grep across project |
| `<leader>sw` | Search for word under cursor |
| `<leader>sh` | Search help tags |
| `<leader>sd` | Search diagnostics (LSP) |
| `<leader>sc` | Search Neovim config files |
| `<leader>sp` | Search clipboard history (neoclip) |
| `<leader>?` | Recently opened files (oldfiles) |
| `<leader><space>` | Open buffers |

### Custom Behavior

- **find_files tiebreak:** `.py` files sort above non-`.py` files; `.rst` files sink to the bottom. Useful when Python test/doc pairs have the same name prefix.
- **help_tags:** Pressing `<cr>` opens help in a vertical split.
- **FZF sorter:** Loaded via `telescope-fzf-native.nvim` for faster, typo-tolerant matching.
- **Ignore patterns:** `.git/` and `.venv` directories excluded from file results.

### Inside a Telescope Picker

| Key | Action |
|-----|--------|
| `<C-n>` / `<Down>` | Next item |
| `<C-p>` / `<Up>` | Previous item |
| `<Esc>` | Close picker |
| `<cr>` | Select/default action |
| `<C-t>` | Open in tab |
| `<C-x>` | Open in horizontal split |
| `<C-v>` | Open in vertical split |

---

## aerial.nvim — Code Outline / Symbol Sidebar

**What:** A sidebar listing functions, classes, methods, and other symbols in the current file. Uses Treesitter + LSP for symbol extraction. Jumps between symbols with `]]`/`[[`.

### Keybindings

| Key | Action |
|-----|--------|
| `<leader>a` | Toggle aerial outline sidebar |
| `]]` | Jump to next symbol |
| `[[` | Jump to previous symbol |

### What's Shown

| Language | Symbols |
|----------|---------|
| Python/Lua/etc | Classes, constructors, functions, methods, modules, structs, interfaces |
| Markdown | All heading levels (no filter) |

**Config:** Sidebar opens on the right, minimum width 30 chars.

---

## nvim-ufo — Code Folding

**What:** Modern fold provider using Treesitter for semantic folding (functions, classes, blocks). Starts with folds fully open (`foldlevel=99`), then auto-folds to level 1 on first buffer read (shows top-level structures collapsed).

### Keybindings

| Key | Action |
|-----|--------|
| `zR` | Open all folds |
| `zM` | Close all folds |
| `za` | Toggle fold under cursor |
| `zo` | Open fold under cursor |
| `zc` | Close fold under cursor |

**Behavior:** On buffer read, waits 200ms for ufo to compute folds, then collapses to level 1 (only top-level functions/classes visible). This happens once per buffer per session.
