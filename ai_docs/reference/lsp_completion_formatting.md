# LSP, Completion & Formatting

Plugins that handle language intelligence: autocompletion, go-to-definition, diagnostics, formatting, and LSP server management.

---

## blink.cmp — Completion Engine

**What:** Rust-powered autocompletion engine. Replaces the older nvim-cmp with faster fuzzy matching and a simpler configuration model. Sources: LSP, path, snippets, buffer words.

### Completion Keybindings (Insert Mode)

| Key | Action |
|-----|--------|
| `<CR>` | Accept selected completion |
| `<C-y>` | Accept selected completion (alternative) |
| `<C-n>` / `<Down>` | Next completion item |
| `<C-p>` / `<Up>` | Previous completion item |
| `<C-space>` | Open completion menu / open docs panel |
| `<C-e>` | Hide completion menu |
| `<C-k>` | Toggle signature help |
| `<C-u>` | Scroll signature help up |
| `<C-d>` | Scroll signature help down |

### Command-Line Completion

| Key | Action |
|-----|--------|
| `<Tab>` | Show and insert / accept single match |

### Configuration Notes

- **Preset:** `enter` — `<cr>` accepts, similar to built-in completions.
- **Documentation:** Only shown manually (not auto-popup).
- **Signature:** Enabled, shown in a popup window when toggled.
- **Fuzzy matcher:** Rust-native with Lua fallback.

---

## mason.nvim + mason-lspconfig.nvim — LSP Server Manager

**What:** `mason.nvim` installs and manages language servers, formatters, and linters. `mason-lspconfig.nvim` bridges mason-installed servers into `nvim-lspconfig`.

### Auto-installed Servers

| Server | Language | Notes |
|--------|----------|-------|
| `basedpyright` | Python | Type checking set to "basic" |
| `bashls` | Bash | Shell script support |

### Managing Servers

- `:Mason` — open the Mason UI to browse, install, update, or remove tools.
- `:LspInfo` — shows which LSP clients are attached to the current buffer.

---

## nvim-lspconfig — LSP Configuration

**What:** Standard Neovim LSP client configuration. Sets up language servers and exposes `vim.lsp.buf.*` functions for code navigation.

### LSP Keybindings (via `plugin/lsp_on_attach.lua`)

These are buffer-local and active only after an LSP server attaches:

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gI` | Go to implementation |
| `gr` | Find references (Telescope) |
| `K` | Hover documentation |
| `<C-k>` | Signature help |
| `<leader>ca` | Code action (quick-fix, organize imports) |
| `<leader>f` | Format buffer (conform.nvim) |
| `<leader>rn` | Rename symbol |
| `<leader>D` | Type definition |
| `<leader>ds` | Document symbols (Telescope) |
| `<leader>ws` | Workspace symbols (Telescope) |
| `<leader>wa` | Add workspace folder |
| `<leader>wr` | Remove workspace folder |
| `<leader>wl` | List workspace folders |

---

## conform.nvim — Code Formatter

**What:** Runs formatters on save and on-demand. Configured with an LSP fallback — if a formatter isn't set for the filetype, the LSP's formatting capability is used instead.

### Formatters by Filetype

| Filetype | Formatters |
|----------|-----------|
| Lua | stylua |
| Python | ruff_organize_imports → ruff_fix → ruff_format |

### Behavior

- **Format on save:** Enabled with 500ms timeout. Falls back to LSP formatting if no explicit formatter matches.
- **Manual format:** `<leader>f` while in an LSP-attached buffer.

---

## Diagnostics

### Toggle Virtual Lines

| Key | Action |
|-----|--------|
| `<leader>e` | Toggle diagnostic messages as virtual text lines |

By default, diagnostics appear as inline virtual text. Pressing `<leader>e` switches between inline and full virtual lines (each diagnostic gets its own line below the problematic code).
