# Neovim Configuration Handbook

## Overview

Minimal, opinionated Neovim setup built on **lazy.nvim** with Treesitter, LSP (via Mason), and blink.cmp completion. Colorscheme: **nordfox**. Leader: `<Space>`, Local leader: `\`.

---

## Plugin Stack

| Category | Plugin(s) |
|----------|-----------|
| Package manager | lazy.nvim |
| LSP | nvim-lspconfig, mason.nvim, mason-lspconfig |
| Completion | blink.cmp, friendly-snippets |
| Formatting | conform.nvim (stylua, ruff) |
| Treesitter | nvim-treesitter (highlight, indent) |
| Navigation | aerial.nvim, telescope.nvim, nvim-tree |
| Git | vim-fugitive, gitsigns.nvim, octo.nvim |
| Editing | vim-surround, vim-repeat, Comment.nvim, vim-sleuth |
| UI | indent-blankline, which-key, lualine, ufo (folds) |
| Terminal | Custom floating terminal |
| AI | opencode.nvim |
| Misc | neoclip (clipboard history), vim-tmux-navigator, vimtex |

---

## Keybindings

### General

| Key | Mode | Action |
|-----|------|--------|
| `jk` | i, v, t | Escape to normal mode |
| `Y` | n | Yank to end of line |
| `>` / `<` | v | Indent/dedent and reselect |
| `+` / `-` | n | Increment/decrement number |
| `<leader>w` | n | Save |
| `<leader>W` | n | Save and quit |
| `<leader>q` | n | Quit |
| `<leader>Q` | n | Force quit |

### File Tree (nvim-tree)

| Key | Mode | Action |
|-----|------|--------|
| `<C-b>` | n, i | Toggle file tree |
| `<leader>b` | n | Focus file tree |

### Floating Terminal

| Key | Mode | Action |
|-----|------|--------|
| `<leader>t` | n | Toggle floating terminal |
| `<Esc>` / `jk` | t | Exit terminal mode |

---

### Navigation & Symbols (aerial.nvim)

| Key | Mode | Action |
|-----|------|--------|
| `]]` | n | Jump to next symbol (function/heading) |
| `[[` | n | Jump to previous symbol |
| `<leader>a` | n | Toggle aerial outline panel |

Context-aware: jumps between functions/classes in Python/Lua, headings in Markdown.

---

### LSP (active when server attaches)

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gI` | Go to implementation |
| `gr` | References (Telescope) |
| `K` | Hover docs |
| `<C-k>` | Signature help |
| `<leader>ca` | Code action |
| `<leader>rn` | Rename symbol |
| `<leader>f` | Format buffer |
| `<leader>D` | Type definition |
| `<leader>ds` | Document symbols (Telescope) |
| `<leader>ws` | Workspace symbols (Telescope) |
| `<leader>wa/wr/wl` | Add/remove/list workspace folders |

### Diagnostics

| Key | Action |
|-----|--------|
| `<leader>e` | Toggle diagnostic virtual lines |

---

### Telescope (fuzzy finder)

| Key | Action |
|-----|--------|
| `<leader>sf` | Search files (incl. hidden) |
| `<leader>sg` | Live grep |
| `<leader>sw` | Grep current word |
| `<leader>sh` | Search help tags |
| `<leader>sd` | Search diagnostics |
| `<leader>sc` | Search config files |
| `<leader>sp` | Search paste registers (neoclip) |
| `<leader>?` | Recently opened files |
| `<leader><space>` | Open buffers |

---

### Completion (blink.cmp)

| Key | Mode | Action |
|-----|------|--------|
| `<CR>` | i | Accept completion |
| `<C-y>` | i | Accept completion (alt) |
| `<C-n>` / `<C-p>` | i | Next/prev item |
| `<C-space>` | i | Open menu / open docs |
| `<C-e>` | i | Hide menu |
| `<C-k>` | i | Toggle signature help |
| `<C-u>` / `<C-d>` | i | Scroll signature up/down |
| `<Tab>` | cmdline | Show and accept |

---

### Git

#### Fugitive

`:G` opens an interactive git status split. Stage with `s`, commit with `cc`, push with `:G push`.

#### Gitsigns (buffer-local)

Signs in the gutter for added/changed/deleted lines. Use `:Gitsigns` commands for hunk navigation and staging.

#### Octo (GitHub integration)

| Key | Action |
|-----|--------|
| `<leader>gi` | List issues |
| `<leader>gp` | List PRs |
| `<leader>gs` | GitHub search |
| `<leader>gc` | Create PR |
| `<leader>gm` | Merge PR |
| `<leader>go` | Checkout PR |
| `<leader>gd` | PR diff |
| `<leader>gB` | Open PR in browser |
| `<leader>gk` | PR checks |
| `<leader>grs` | Start review |
| `<leader>grS` | Submit review |
| `<leader>grr` | Resume review |
| `<leader>grd` | Discard review |
| `<leader>grc` | Review comments |

---

### Folds (nvim-ufo)

| Key | Action |
|-----|--------|
| `zR` | Open all folds |
| `zM` | Close all folds |

Standard `za`, `zo`, `zc` also work per-fold.

---

### OpenCode (AI assistant)

| Key | Action |
|-----|--------|
| `<leader>ot` | Toggle OpenCode panel |
| `<leader>oa` | Ask OpenCode about selection/buffer |
| `<leader>oo` | OpenCode operations menu |
| `go` / `goo` | Add range/line to OpenCode context |
| `<leader>ol` | List sessions |
| `<leader>on` | New session |
| `<leader>os` | Select session |
| `<leader>oxd` | Ask about diagnostics |
| `<leader>oxe` | Explain |
| `<leader>oxf` | Fix |
| `<leader>oxt` | Generate tests |
| `<leader>oxr` | Review |
| `<leader>oxo` | Optimize |
| `<leader>oxc` | Document |
| `<leader>oxi` | Implement |

---

### Filetype-specific

| Filetype | Key | Action |
|----------|-----|--------|
| Python | `<F5>` | Save and run with python3 |
| Lua | `<space>x` | Execute current line / selection as Lua |

---

## Formatting (auto on save)

| Language | Formatters |
|----------|-----------|
| Lua | stylua |
| Python | ruff (organize imports, fix, format) |

Format-on-save is enabled (500ms timeout, falls back to LSP).

---

## LSP Servers (auto-installed via Mason)

- **Python**: basedpyright
- **Bash**: bashls
- **Lua**: configured via lazydev.nvim (Neovim API aware)

---

## Workflow Patterns

### Exploring a codebase
1. `<leader>sf` to find files
2. `<leader>sg` to grep across the project
3. `<leader><space>` to switch between open buffers
4. `<C-b>` for the file tree

### Navigating code structure
1. `]]` / `[[` to jump between functions/headings
2. `<leader>a` to open the symbol outline
3. `<leader>ds` for a searchable symbol list (Telescope)

### Editing workflow
1. `gc` (Comment.nvim) to toggle comments on lines/selections
2. `cs"'` / `ds"` / `ysiw"` (vim-surround) to change/delete/add surrounds
3. `>` / `<` in visual mode to indent with reselect

### Git workflow
1. `:G` for fugitive status, stage, commit
2. Gutter signs show changes inline
3. `<leader>gp` to list PRs, `<leader>gc` to create, `<leader>grs` to start review

### AI-assisted development
1. `go` to add code context, `<leader>oa` to ask
2. `<leader>oxf` to ask for a fix, `<leader>oxt` for tests
3. `<leader>ot` to toggle the chat panel

### Terminal
1. `<leader>t` for a floating terminal (persists state)
2. `jk` or `<Esc>` to return to normal mode from terminal

### Tmux integration
`<C-h/j/k/l>` seamlessly moves between Neovim splits and tmux panes (vim-tmux-navigator).
