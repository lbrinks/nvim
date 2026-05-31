# Git Workflow

Plugins for viewing git changes, resolving merge conflicts, and navigating diffs.

---

## gitsigns.nvim — Git Gutter Signs

**What:** Shows git status signs in the gutter (`+` added, `~` changed, `_` deleted). Also provides commands for hunk staging, resetting, and previewing.

**This config:** Only sets gutter signs. No keybindings configured for interactive hunk operations. Access via `:Gitsigns` commands if needed.

---

## diffview.nvim — Git Diff Viewer

**What:** Visual diff tool for reviewing changes, exploring file history, and resolving merge conflicts. Opens a dedicated split layout with a file panel on the left and diffs on the right.

### Keybindings (Global)

| Key | Action |
|-----|--------|
| `<leader>dv` | Open diffview — all uncommitted/staged changes |
| `<leader>dc` | Close diffview |
| `<leader>dh` | Show commit history of current file (`%`) |
| `<leader>dH` | Show full branch commit history |
| `<leader>dm` | Open merge-conflict mode (3-way: ours/base/theirs) |

### Inside a Diffview Split

| Key | Context | Action |
|-----|---------|--------|
| `q` | view / file_panel / file_history | Close diffview |
| `<leader>ge` | view | Focus the file panel |
| `<leader>gb` | view | Toggle file panel visibility |

### Layouts

| Context | Layout | Description |
|---------|--------|-------------|
| Default diff | `diff2_horizontal` | Two-pane horizontal split |
| Merge conflicts | `diff3_mixed` | Three-pane with base+ours+theirs |
| File history | `diff2_horizontal` | Per-commit diff view |

### File Panel

- Position: left, 35 chars wide
- Flat tree structure (directories collapsed)
- Folder status icons shown only when folded

---

## git-conflict.nvim — Merge Conflict Resolution

**What:** Inline conflict marker detection and resolution. Highlights `<<<<<<<`, `=======`, `>>>>>>>` markers and provides one-key resolution. When inside a conflicted file, LSP diagnostics are suppressed to reduce noise.

### Keybindings

| Key | Action |
|-----|--------|
| `]x` | Jump to next conflict marker |
| `[x` | Jump to previous conflict marker |
| `<leader>gco` | Choose **ours** (HEAD / current branch) |
| `<leader>gct` | Choose **theirs** (incoming / merge branch) |
| `<leader>gcb` | Choose **both** (keep both sides) |
| `<leader>gcn` | Choose **none** (delete both sides) |
| `<leader>gcl` | List all conflicts in quickfix window |

### Resolution Highlights

- **Incoming** (theirs): rendered with `DiffAdd` highlight
- **Current** (ours): rendered with `DiffText` highlight

---

## Typical Merge Conflict Workflow

When a `git pull`/`merge`/`rebase` produces conflicts:

```
1. <leader>dm     → Open 3-way merge view (ours / base / theirs) + file panel
2. Select file     → Jump into conflicted file
3. ]x              → Jump to first conflict
4. <leader>gco     → Keep ours, or
   <leader>gct     → Keep theirs, or
   <leader>gcb     → Keep both
5. ]x              → Move to next conflict, repeat
6. [x              → Go back if needed
7. q               → Close diffview when done
8. <leader>gcl     → (Alternative) List all conflicts, jump between files
```

**Tip:** Use `]x`/`[x` for quick inline resolution within a single file. Use `<leader>dm` for complex multi-file merges where you need the full 3-way visual context.

---

## Non-Conflict Diffview Uses

- `<leader>dv` — review all working tree changes (like `git diff` with a UI)
- `<leader>dh` — browse the commit history of the current file
- `<leader>dH` — browse full branch commit history
