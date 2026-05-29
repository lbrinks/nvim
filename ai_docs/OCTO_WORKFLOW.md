# Octo.nvim PR/Issue Workflow

## Overview

Octo.nvim integrates GitHub issues and pull requests directly into Neovim. The workflow has two layers:

1. **Global keybindings** (`<leader>g*`) — work anywhere, open lists and trigger commands
2. **Buffer-local keybindings** — active only inside Octo buffers (issues, PRs, reviews), context-specific

Some keys shadow each other across contexts—this is intentional. When you're inside a PR reviewing code, `<leader>grr` means "add rocket reaction"; at the command line, it means "resume review". The context determines which binding is active.

---

## Entry Points (Global Keybindings)

These work from anywhere and open Octo lists/views.

| Key | Action | Context |
|---|---|---|
| `<leader>gi` | List issues | Global |
| `<leader>gp` | List PRs | Global |
| `<leader>gs` | Search (issues/PRs) | Global |
| `<leader>gc` | Create PR | Global |
| `<leader>gm` | Merge PR | Global |
| `<leader>grs` | Start review | Global |
| `<leader>grS` | Submit review | Global |
| `<leader>grr` | **Resume review** | Global |
| `<leader>grd` | Discard review | Global |
| `<leader>grc` | List review comments | Global |
| `<leader>gk` | View PR checks/CI | Global |
| `<leader>go` | Checkout PR branch | Global |
| `<leader>gd` | View PR changes/diff | Global |
| `<leader>gB` | Open PR in browser | Global |

---

## Working with Issues

### View a single issue

```
<leader>gi  →  Select issue from list  →  Opens in buffer
```

### Inside an issue buffer

| Key | Action |
|---|---|
| `<leader>gic` | Close issue |
| `<leader>gio` | Reopen issue |
| `<leader>gil` | List open issues |
| `<C-r>` | Reload issue |
| `<C-b>` | Open in browser |
| `<C-y>` | Copy URL to clipboard |
| `<leader>gaa` | Add assignee |
| `<leader>gad` | Remove assignee |
| `<leader>glc` | Create label |
| `<leader>gla` | Add label |
| `<leader>gld` | Remove label |
| `<leader>gca` | Add comment |
| `<leader>gcd` | Delete comment |
| **Reactions** (on comments/issue) | |
| `<leader>grp` | Add party reaction 🎉 |
| `<leader>grh` | Add heart reaction ❤️ |
| `<leader>gre` | Add eyes reaction 👀 |
| `<leader>gr+` | Add thumbs up reaction 👍 |
| `<leader>gr-` | Add thumbs down reaction 👎 |
| `<leader>grr` | Add rocket reaction 🚀 |
| `<leader>grl` | Add laugh reaction 😄 |
| `<leader>grc` | Add confused reaction 😕 |

---

## Working with Pull Requests

### View and select PRs

```
<leader>gp  →  Select PR from list  →  Opens in buffer
```

### Inside a PR buffer (not reviewing)

| Key | Action |
|---|---|
| `<leader>gpo` | Checkout PR branch locally |
| `<leader>gpm` | Merge PR |
| `<leader>gps` | Squash and merge PR |
| `<leader>gpr` | Rebase and merge PR |
| `<leader>gpc` | List PR commits |
| `<leader>gpf` | List PR changed files |
| `<leader>gpd` | Show PR diff |
| `<leader>gic` | Close PR |
| `<leader>gio` | Reopen PR |
| `<C-r>` | Reload PR |
| `<C-b>` | Open in browser |
| `<C-y>` | Copy URL |
| `<leader>gaa` | Add assignee |
| `<leader>gad` | Remove assignee |
| `<leader>glc` | Create label |
| `<leader>gla` | Add label |
| `<leader>gld` | Remove label |
| `<leader>gca` | Add comment |
| `<leader>gcd` | Delete comment |
| `<leader>gva` | Add reviewer |
| `<leader>gvd` | Remove reviewer |
| **Reactions** | Same as issues |
| `<leader>grp`, `<leader>grh`, etc. | Add reactions to PR/comments |

---

## Code Review Workflow

### Step 1: Start a review

```
<leader>grs  →  Enter review mode (pending state)
```

### Step 2: Navigate the diff

```
<leader>gd  →  Open PR changes in diff view
```

Or from within a PR buffer:
- `<leader>ge` — Focus on file panel (changed files list)
- `<leader>gb` — Toggle file panel visibility

### Step 3: In the review diff (code view)

| Key | Action |
|---|---|
| `]t` | Jump to next review thread/comment |
| `[t` | Jump to prev review thread/comment |
| `]q` | Jump to next changed file |
| `[q` | Jump to prev changed file |
| `[Q` | Jump to first changed file |
| `]Q` | Jump to last changed file |
| `<leader>gca` | Add review comment (on current line) |
| `<leader>gsa` | Add review suggestion (code fix) |
| `<leader>gvs` | Submit review (approve/request-changes/comment) |
| `<leader>gvx` | Discard review (abandon pending comments) |
| `<leader>gb` | Toggle file panel |
| `<leader>ge` | Focus file panel |
| `<leader>g<space>` | Toggle file as "viewed" |

### Step 4: Handle review threads

**Inside a review thread (comment section):**

| Key | Action |
|---|---|
| `<leader>gti` | Go to associated issue |
| `<leader>gca` | Add reply to thread |
| `<leader>gcd` | Delete your comment |
| `<leader>gtr` | Mark thread as resolved |
| `<leader>gtu` | Mark thread as unresolved |

### Step 5: Submit the review

```
<leader>gvs  →  Open submit window
```

In the submit window:

| Key | Action |
|---|---|
| `<C-a>` | Approve review |
| `<C-m>` | Comment review (no approval) |
| `<C-r>` | Request changes |
| `<C-c>` | Close/cancel |

After submission, the review is posted to GitHub and the pending state is cleared.

---

## Telescope Picker (Issue/PR Selection)

When you run `<leader>gi` or `<leader>gp`, you get a Telescope picker. Inside the picker:

| Key | Action |
|---|---|
| `<C-b>` | Open selected issue/PR in browser |
| `<C-y>` | Copy URL to clipboard |
| `<C-o>` | Checkout PR (PRs only) |
| `<C-r>` | Merge PR (PRs only) |
| `<cr>` | Open issue/PR in buffer |

---

## Context Awareness: Why Keys Overlap

### Example: `<leader>grr`

| Context | Key | Meaning |
|---|---|---|
| **Global** (command line) | `<leader>grr` | **Resume review** (top-level command) |
| **Inside issue/PR buffer** | `<leader>grr` | **Add rocket reaction** (buffer-local mapping) |
| **Inside review diff** | `<leader>grr` | **Add rocket reaction** (review_diff context) |

This isn't a conflict—Neovim checks buffer-local mappings first, then falls back to global. When you're in an Octo buffer, the buffer-local mapping takes precedence.

### Other overlapping keys

- `<leader>grc` — "review comments" (global) vs "confused reaction" (buffer-local)
- `<leader>gre` — "eyes reaction" (buffer-local only)
- `<leader>grh` — "heart reaction" (buffer-local only)

**Workflow implication:** Use the global versions from outside buffers (e.g., to start a review from the command line), use the buffer-local versions when inside an Octo buffer (for reactions while reading).

---

## Common Workflows

### Workflow 1: Review and approve a PR

```
1. <leader>gp                → List PRs
2. [Select your PR]
3. <leader>gd               → View diff
4. ]t                       → Jump to first thread (if exists)
5. ]q                       → Jump through changed files
6. <leader>gca              → Add comments on specific lines
7. <leader>gvs              → Submit review
8. <C-a>                    → Approve (in submit window)
```

### Workflow 2: Request changes on a PR

```
1. <leader>gp               → List PRs
2. [Select PR]
3. <leader>gd               → View diff
4. Navigate to problematic file/line
5. <leader>gsa              → Add suggestion (with fix)
6. <leader>gvs              → Submit review
7. <C-r>                    → Request changes (in submit window)
```

### Workflow 3: Respond to review comments

```
1. <leader>gp               → List PRs
2. [Select PR]
3. <leader>gd               → View diff with threads
4. ]t                       → Jump to next unresolved thread
5. <leader>gca              → Reply to thread
6. <leader>gtr              → Resolve thread (once addressed)
```

### Workflow 4: Add reactions to comments

```
1. [Inside issue/PR buffer, reading comments]
2. Position cursor on comment/thread
3. <leader>grp              → Add 🎉 reaction
4. <leader>grh              → Add ❤️ reaction
5. etc.
```

### Workflow 5: Manage assignees/labels

```
1. [Inside issue/PR buffer]
2. <leader>gaa              → Add assignee (pick from list)
3. <leader>gla              → Add label
4. <leader>gld              → Remove label
```

---

## Tips & Tricks

### Resume a multi-step review

If you start a review but don't submit it right away:

```
<leader>grr  →  Resume pending review  →  <leader>gd to continue coding
```

Your comments are saved in pending state until you submit.

### Quick browser access

```
<leader>gB  →  Open current PR in browser (from command line)
<C-b>       →  Open from Telescope picker or inside buffer
```

### Navigate threads efficiently

Inside a review diff:
- `]t` to jump between comment threads (only in review_diff context)
- `<leader>gti` from inside a thread to jump to the related issue

### Check CI status

```
<leader>gk  →  View all PR checks/status (useful before merging)
```

### Checkout and test locally

```
<leader>go  →  Checkout the PR branch locally
              (equivalent to: git fetch && git checkout -b branch-name)
```

---

## Configuration Notes

- **Token handling:** GitHub token is automatically injected (Coder environment aware)
- **Default merge method:** Squash merge (configurable)
- **Picker:** Telescope (integrates with your existing setup)
- **Order:** Issues/PRs sorted by creation date, newest first
- **3-way merge:** Not used in this config (Octo is for GitHub interaction, not local conflict resolution—use diffview.nvim for that)

---

## Limitations & Workarounds

1. **Local conflict resolution:** Octo can't resolve merge conflicts in your working tree. Use `diffview.nvim` for that (`<leader>dm`).

2. **Unresolved thread filtering:** Octo doesn't have a "jump to next unresolved thread" command. Workaround: `]t` jumps all threads; check if marked with icon.

3. **Draft reviews:** Once submitted, reviews can't be edited. Discard with `<leader>grd` and start over if needed.

4. **SSH key requirement:** If your repo uses SSH, ensure SSH keys are loaded (`ssh-add`).
