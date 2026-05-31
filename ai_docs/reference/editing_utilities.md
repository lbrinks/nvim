# Editing Utilities

Plugins that enhance text editing, clipboard history, and repetitive operations.

---

## vim-surround — Surround Manipulation

**What:** Add, change, or delete surrounding brackets, quotes, tags, etc. Works in normal and visual modes. Pairs with vim-repeat so `.` repeats surround operations.

### Normal Mode: Changing Surrounds (`cs`)

| Command | Before | After |
|---------|--------|-------|
| `cs"'` | `"hello"` | `'hello'` |
| `cs'<q>` | `'hello'` | `<q>hello</q>` |
| `cs'"` | `'hello'` | `"hello"` |
| `cs])` | `[hello]` | `(hello)` |
| `cst"` | `<div>hello</div>` | `"hello"` |

### Normal Mode: Deleting Surrounds (`ds`)

| Command | Before | After |
|---------|--------|-------|
| `ds"` | `"hello"` | `hello` |
| `ds(` | `(hello)` | `hello` |
| `dst` | `<div>hello</div>` | `hello` |

### Normal Mode: Adding Surrounds (`ys`)

| Command | Before | After |
|---------|--------|-------|
| `ysiw"` | `hello` (cursor on word) | `"hello"` |
| `ysiw)` | `hello` (cursor on word) | `(hello)` |
| `ysst` | visual selection of text | `<div>text</div>` |
| `yss)` | whole line | `(whole line)` |
| `yS` (all modes) | place surrounds on new lines |

### Visual Mode: Surrounding Selection (`S`)

| Command | Before | After |
|---------|--------|-------|
| `S"` | selected text | `"selected text"` |
| `S(` | selected text | `(selected text)` (space-padded) |
| `S<t>` | selected text | `<t>selected text</t>` |
| `SB` (with `yS` style) | selected text | `{\n  selected text\n}` |

### Mnemonics

- `cs` = **c**hange **s**urround
- `ds` = **d**elete **s**urround
- `ys` = **y**ou **s**urround (add)
- `S` = **S**urround (visual mode)
- `t` = **t**ag (HTML/XML-style)
- `b`, `B`, `r`, `a` = alias for `)`, `}`, `]`, `>`

---

## vim-repeat — Enhanced Repeat

**What:** Makes the `.` (dot) command work with plugin-defined operations. After using a surround or comment operation, pressing `.` repeats it on other targets.

**Keybinding:** `.` (standard Vim repeat, no additional mappings)

---

## Comment.nvim — Toggle Comments

**What:** Comment/uncomment lines or visual selections with `gc` (operator) or `gcc` (current line). Language-aware — uses the correct comment syntax for each filetype.

### Keybindings

| Key | Mode | Action |
|-----|------|--------|
| `gc` | n, v | Comment operator (e.g., `gc3j` = comment 3 lines down) |
| `gcc` | n | Toggle comment on current line |
| `gc` | v | Toggle comment on visual selection |

**Repeat:** Works with `.` (vim-repeat) — you can `gcc` then `.` repeatedly to comment multiple lines.

---

## nvim-neoclip.lua — Persistent Clipboard History

**What:** Tracks yanks, deletes, and macros across Neovim sessions. Stores history in a SQLite database so entries survive restarts.

**Capacity:** Last 1000 entries, entries up to ~1MB each.

### Access

| Key | Action |
|-----|--------|
| `<leader>sp` | Open clipboard history (Telescope picker) |

### Inside the Telescope Picker

| Key | Mode | Action |
|-----|------|--------|
| `<cr>` | i | Paste entry at cursor |
| `p` | n | Paste entry at cursor |
| `P` | n | Paste entry behind cursor |
| `q` | n | Replay macro entry |
| `<C-q>` | i | Replay macro entry |
| `d` | n | Delete entry from history |
| `<C-d>` | i | Delete entry from history |
| `e` | n | Edit entry text before pasting |
| `<C-e>` | i | Edit entry text before pasting |

**Tips:**
- Entries include both yanks and deletes — useful for recovering accidentally deleted text.
- Macro history (`enable_macro_history = true`) records recorded macros, replayable from the picker.
- The prompt defaults to insert mode, so you can start typing to fuzzy-filter immediately.
