# Octo.nvim — GitHub Integration

Full-reference documentation for octo.nvim as configured. Covers issue tracking, PR management, code reviews, and the custom issue board.

---

## Quick Workflow Guide

### Review a PR end-to-end

```
<leader>gp     → List PRs, pick one
<leader>grs    → Start a review
<leader>gd     → Open the PR diff
]q / [q        → Navigate changed files
]t / [t        → Navigate review threads
<leader>gca    → Add a comment on current line
<leader>gsa    → Add a code suggestion
<leader>gvs    → Submit review
<C-a>          → Approve (in submit window)
```

### Browse and manage issues

```
<leader>gi     → List issues via Telescope picker
<leader>gl     → Open the persistent issue board (custom)
<leader>gI     → Filter issues by label (prompt)
<leader>gs     → GitHub search (issues + PRs)
```

### Create and manage PRs

```
<leader>gc     → Create a new PR from the current branch
<leader>go     → Checkout a PR branch locally
<leader>gm     → Merge a PR (opens PR list, then squash-merge)
<leader>gk     → Check CI status on a PR
<leader>gB     → Open current PR in browser
```

---

## Entry Points — Global Keybindings

Work from anywhere; open lists, views, or trigger commands.

| Key | Action |
|-----|--------|
| `<leader>gi` | **Issue list** — Telescope picker of open issues |
| `<leader>gI` | **Issues by label** — prompted for a label filter |
| `<leader>gl` | **Issue board** — custom persistent issue list buffer |
| `<leader>gp` | **PR list** — Telescope picker of open pull requests |
| `<leader>gs` | **Search** — GitHub search (issues + PRs) |
| `<leader>gc` | **Create PR** — open PR from current branch |
| `<leader>gm` | **Merge PR** — opens list, merge selected PR |
| `<leader>grs` | **Start review** — begin a pending code review |
| `<leader>grS` | **Submit review** — submit pending review |
| `<leader>grr` | **Resume review** — continue an interrupted review |
| `<leader>grd` | **Discard review** — abandon pending review comments |
| `<leader>grc` | **Review comments** — list all comments on a PR |
| `<leader>gk` | **PR checks** — view CI/status checks |
| `<leader>go** | **Checkout PR** — fetch and checkout PR branch locally |
| `<leader>gd** | **PR diff** — view PR changes with file panel |
| `<leader>gB** | **Open in browser** — open current PR in browser |

---

## Telescope Picker Keybindings

Active when selecting an issue or PR from a Telescope list.

| Key | Action |
|-----|--------|
| `<cr>` | Open issue/PR in a buffer |
| `<C-b>` | Open in browser |
| `<C-y>` | Copy URL to system clipboard |
| `<C-o>` | Checkout PR (PR picker only) |
| `<C-r>` | Merge PR (PR picker only, squash-merge by default) |

---

## Issue Mode — Buffer-Local Keybindings

Active when viewing a single issue in a buffer.

### Lifecycle

| Key | Action |
|-----|--------|
| `<leader>gic` | Close issue |
| `<leader>gio` | Reopen issue |
| `<leader>gil` | List open issues |
| `<C-r>` | Reload issue |
| `<C-b>` | Open in browser |
| `<C-y>` | Copy URL |

### Assignees & Labels

| Key | Action |
|-----|--------|
| `<leader>gaa` | Add assignee |
| `<leader>gad` | Remove assignee |
| `<leader>glc` | Create label |
| `<leader>gla` | Add label |
| `<leader>gld` | Remove label |

### Comments

| Key | Action |
|-----|--------|
| `<leader>gca` | Add comment |
| `<leader>gcd` | Delete comment |

### Reactions (on comments/issue body)

| Key | Reaction |
|-----|----------|
| `<leader>grp` | Party 🎉 |
| `<leader>grh` | Heart ❤️ |
| `<leader>gre` | Eyes 👀 |
| `<leader>gr+` | Thumbs up 👍 |
| `<leader>gr-` | Thumbs down 👎 |
| `<leader>grr` | Rocket 🚀 |
| `<leader>grl` | Laugh 😄 |
| `<leader>grc` | Confused 😕 |

---

## Pull Request Mode — Buffer-Local Keybindings

Active when viewing a single PR in a buffer (not during review).

### Lifecycle & Meta

| Key | Action |
|-----|--------|
| `<leader>gpo` | Checkout PR branch locally |
| `<leader>gpm` | Merge PR (default method) |
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

### Reviewers, Assignees, Labels, Comments

| Key | Action |
|-----|--------|
| `<leader>gva` | Add reviewer |
| `<leader>gvd` | Remove reviewer |
| `<leader>gaa` | Add assignee |
| `<leader>gad` | Remove assignee |
| `<leader>glc` | Create label |
| `<leader>gla` | Add label |
| `<leader>gld` | Remove label |
| `<leader>gca` | Add comment |
| `<leader>gcd` | Delete comment |

### Reactions

Same 8 reaction keys as issue mode (`<leader>grp/h/e/+/-/r/l/c`).

---

## Code Review Mode

Code review has multiple sub-contexts: the review diff view, the file panel, review threads, and the submit window.

### Step 1: Start a Review

| Key | Action |
|-----|--------|
| `<leader>grs` | **Start review** — enters pending review state |

While a review is active, the file panel and diff view are available.

### Review Diff View (Code + Threads)

Active when viewing PR changes with review comments overlaid.

| Key | Action |
|-----|--------|
| `<leader>gca` | Add review comment on current line |
| `<leader>gsa` | Add review suggestion (code change proposal) |
| `<leader>gvs` | Submit review (opens submit window) |
| `<leader>gvx` | Discard review (abandon all pending comments) |
| `<leader>ge` | Focus the changed files panel |
| `<leader>gb` | Toggle changed files panel |
| `<leader>g<space>` | Toggle file as viewed/unviewed |
| `]t` | Jump to next review thread |
| `[t` | Jump to previous review thread |
| `]q` | Jump to next changed file |
| `[q` | Jump to previous changed file |
| `]Q` | Jump to last changed file |
| `[Q` | Jump to first changed file |
| `<C-c>` | Close review tab |

### File Panel (Changed Files List)

| Key | Action |
|-----|--------|
| `j` / `k` | Move down/up |
| `<cr>` | Show diff for selected file |
| `R` | Refresh changed files |
| `<leader>gvs` | Submit review |
| `<leader>gvx` | Discard review |
| `<leader>ge` | Focus file panel |
| `<leader>gb` | Toggle file panel |
| `]q` / `[q` | Next/prev changed file |
| `]Q` / `[Q` | First/last changed file |
| `<leader>g<space>` | Toggle viewed |
| `<C-c>` | Close review tab |

### Review Threads (Discussion on a specific comment)

| Key | Action |
|-----|--------|
| `<leader>gti` | Navigate to associated issue |
| `<leader>gca` | Add reply comment |
| `<leader>gsa` | Add suggestion |
| `<leader>gcd` | Delete your comment |
| `<leader>gtr` | Resolve thread |
| `<leader>gtu` | Unresolve thread |

### Submit Window (Final Review Decision)

| Key | Action |
|-----|--------|
| `<C-a>` | **Approve** the PR |
| `<C-m>` | **Comment** (neutral review, no approval) |
| `<C-r>` | **Request changes** |
| `<C-c>` | Close/cancel |

---

## Custom Issue Board (`<leader>gl`)

A persistent scratch buffer (`plugin/octo_issue_list.lua`) that displays GitHub issues with filtering. Functions as a lightweight kanban alternative.

### Board Keybindings

| Key | Action |
|-----|--------|
| `<cr>` | Open issue under cursor (in right split) |
| `<Tab>` | Preview issue in right split (keeps focus on list) |
| `r` | Refresh issue list |
| `f` | Filter by label (Telescope picker of repo labels) |
| `F` | Clear label filter |
| `m` | Show issues assigned to you |
| `u` | Show unassigned issues |
| `a` | Filter by assignee (prompt) |
| `A` | Clear assignee filter |
| `q` | Close the issue board |

### Behavior

- Opens in the current window. Pressing `<cr>` or `<Tab>` on an issue opens it in a vertical split to the right.
- Filters are applied simultaneously: you can filter by label AND assignee at the same time.
- The board head shows the current repo and active filters.
- The buffer is named "GitHub Issues" and persists until closed.

---

## Configuration Notes

- **Token handling:** In a Coder workspace, the token is fetched from `coder external-auth access-token primary-github`. Otherwise, relies on the standard `gh` CLI auth.
- **Pin:** Currently pinned to a specific commit for a fragment deduplication fix.
- **Default merge:** Squash merge. Override with `<leader>gpr` (rebase) or `<leader>gpm` (merge commit).
- **Remote priority:** Checks `upstream` first, then `origin`.
- **Issues/PRs:** Ordered by creation date, newest first.

---

## Context Awareness: Overlapping Keybindings

Some key sequences appear in multiple contexts. Buffer-local mappings take precedence over global ones.

| Key | Global Context | Issue/PR Buffer Context |
|-----|---------------|------------------------|
| `<leader>grr` | Resume review | Rocket reaction 🚀 |
| `<leader>grc` | List review comments | Confused reaction 😕 |
| `<leader>gre` | (global: resume, shadowed) | Eyes reaction 👀 |
| `<leader>grh` | (global: resume, shadowed) | Heart reaction ❤️ |
