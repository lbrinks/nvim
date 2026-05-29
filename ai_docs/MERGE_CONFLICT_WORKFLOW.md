# Merge Conflict Resolution Workflow

## Setup

Two plugins are configured for merge conflict resolution:

- **git-conflict.nvim** — inline conflict marker highlighting and resolution
- **diffview.nvim** — multi-file visual diff/merge tool

## Quick Reference

### Opening Conflict Resolution Views

| Key | Action |
|---|---|
| `<leader>dv` | Open diffview — shows all changed/conflicted files |
| `<leader>dm` | Open diffview in merge-conflict mode (3-way diff: ours / base / theirs) |

### Navigating Between Conflicts

| Key | Action |
|---|---|
| `]x` | Jump to next conflict marker in current file |
| `[x` | Jump to previous conflict marker in current file |
| `<leader>gcl` | List all conflicts in quickfix window (jump between files) |

### Resolving Individual Conflicts

| Key | Action |
|---|---|
| `<leader>gco` | Keep **ours** (current branch) |
| `<leader>gct` | Keep **theirs** (incoming branch) |
| `<leader>gcb` | Keep **both** (concatenated) |
| `<leader>gcn` | Keep **none** (delete both sides) |

### Closing

| Key | Action |
|---|---|
| `<leader>dc` | Close diffview |
| `q` | Close diffview (from within the diff/file panel) |

---

## Detailed Workflow

### Scenario: You pull/rebase/merge and get conflicts

#### Step 1 — Assess the situation

```
<leader>dv  →  Open diffview to see all changed/conflicted files
```

This opens a split view with:
- **Left panel:** file tree (changed files marked, conflicted files highlighted)
- **Center/right:** diff splits showing changes

#### Step 2 — Choose merge view mode

For a full 3-way merge (ours / base / theirs):
```
<leader>dm  →  Open in merge-tool mode (diff3_mixed layout)
```

Or manually navigate the file panel and open files one by one.

#### Step 3 — Navigate to conflicts

Jump through conflict markers in the current file:
```
]x  →  Go to next conflict
[x  →  Go to previous conflict
```

Or see all conflicts at once:
```
<leader>gcl  →  List conflicts in quickfix, jump between files
```

#### Step 4 — Resolve each conflict

Conflict markers look like:
```
<<<<<<< HEAD
  our version
=======
  their version
>>>>>>>
```

Position cursor on the conflict and choose:

| Resolution | Command | What it does |
|---|---|---|
| Keep ours | `<leader>gco` | Keeps `HEAD` (current branch), deletes theirs |
| Keep theirs | `<leader>gct` | Keeps incoming (their branch), deletes ours |
| Keep both | `<leader>gcb` | Keeps both versions (removes markers) |
| Delete both | `<leader>gcn` | Removes both versions and markers |

#### Step 5 — Verify and close

After resolving all conflicts:
```
<leader>dc  →  Close diffview
```

Or press `q` from within the diffview splits.

The files are marked as resolved in git's index (conflict markers gone), ready for `git add` and commit.

---

## Non-Conflict Uses of diffview

Even without conflicts, diffview is useful for:

### Review uncommitted changes
```
<leader>dv  →  See all changes like `git diff` in a proper UI
```

### File history
```
<leader>dh  →  See commit history of the current file
<leader>dH  →  See full branch history
```

---

## Mental Model

### git-conflict.nvim

- **When to use:** Single file with conflicts, quick inline resolution
- **Workflow:** Stay in your buffer → `]x`/`[x` to jump → `<leader>gc{o,t,b,n}` to pick
- **Advantage:** Fast, minimal context switching

### diffview.nvim

- **When to use:** Multi-file conflicts, complex merges, or when you want full context
- **Workflow:** `<leader>dm` → file panel shows all conflicts → navigate/resolve → `q` to close
- **Advantage:** Visual, shows base+ours+theirs simultaneously, file panel navigation

### Typical flow

1. `<leader>dm` — open merge tool to see all conflicted files
2. Select a file from the panel (or `]x` to jump to first conflict)
3. In the diff splits, identify which parts to keep
4. `<leader>gco`/`gct`/`gcb`/`gcn` to resolve
5. `]x` to move to next conflict in that file
6. Repeat until all conflicts in file are done
7. Cycle to next conflicted file or close with `q`

---

## Configuration Notes

### git-conflict.nvim

- Highlights conflict markers using `DiffAdd` (incoming) and `DiffText` (current) colors
- Provides plugin mappings; keybinds in this config wrap them for consistency (`<leader>gc*` namespace)
- Disables LSP diagnostics during resolution to reduce noise

### diffview.nvim

- Configured with `diff2_horizontal` for normal diffs, `diff3_mixed` for merge conflicts
- File panel on the left (35 chars wide), flattened tree view
- Word wrapping disabled in diff buffers for clarity
- `q` bound to close from within all diffview contexts for quick escape

Both plugins load lazily (on-demand), so they don't impact startup time.
