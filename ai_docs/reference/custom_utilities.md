# Custom Utilities

Hand-built features that aren't third-party plugins.

---

## Floating Terminal

**What:** A toggleable floating terminal window (80% of editor size, centered, rounded border). Persists its state when hidden — reopening restores the same shell session.

**File:** `plugin/floaterminal.lua`

### Keybindings

| Key | Action |
|-----|--------|
| `<leader>t` | Toggle floating terminal |

### Commands

- `:Floaterminal` — same as `<leader>t`

### Terminal Mode

| Key | Action |
|-----|--------|
| `<Esc>` | Return to normal mode |
| `jk` | Return to normal mode |

---

## Diagnostic Virtual Lines Toggle

**What:** Switches between inline diagnostic messages (default) and full virtual lines (each diagnostic occupies its own line below the problematic code).

**File:** `plugin/diagnostics.lua`

| Key | Action |
|-----|--------|
| `<leader>e` | Toggle diagnostic display mode |

---

## Filetype-Specific Mappings

### Python (`after/ftplugin/python.lua`)

| Key | Action |
|-----|--------|
| `<F5>` | Save and run current file with `python3` |

### Lua (`after/ftplugin/lua.lua`)

| Key | Mode | Action |
|-----|------|--------|
| `<space>x` | n | Execute current line as Lua |
| `<space>x` | v | Execute visual selection as Lua |

---

## General Keybindings (from `init.lua`)

| Key | Mode | Action |
|-----|------|--------|
| `jk` | i, v, t | Escape to normal mode |
| `Y` | n | Yank from cursor to end of line |
| `>` | v | Indent and reselect |
| `<` | v | Dedent and reselect |
| `<leader>w` | n | Save (`:w`) |
| `<leader>W` | n | Save and quit (`:wq`) |
| `<leader>q` | n | Quit |
| `<leader>Q` | n | Force quit (`:q!`) |
| `+` | n | Increment number under cursor |
| `-` | n | Decrement number under cursor |
