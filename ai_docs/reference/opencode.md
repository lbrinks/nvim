# opencode.nvim — AI Agent Integration

Full-reference documentation for the opencode.nvim plugin, which bridges Neovim with the OpenCode AI coding agent.

---

## Quick Workflow Guide

### Ask the AI about your code

```
go              → Send current selection/line to OpenCode
<leader>oa      → Open an "ask" prompt for selection/buffer
<leader>ot      → Toggle the OpenCode chat panel
```

### Run pre-built prompts

```
<leader>oxe     → Explain @this and its context
<leader>oxf     → Fix @diagnostics
<leader>oxt     → Add tests for @this
<leader>oxr     → Review @this
<leader>oxo     → Optimize @this
<leader>oxc     → Add comments to @this
<leader>oxi     → Implement @this
<leader>oxd     → Ask about diagnostics
```

### Manage sessions

```
<leader>on      → New session
<leader>os      → Select session
<leader>ol      → List sessions
<leader>osh     → Share session
<leader>oci     → Interrupt the agent
<leader>occ     → Compact session (reduce context)
<leader>ocu     → Undo last action
<leader>ocr     → Redo last undo
```

### Navigate within a session

```
<S-C-u>         → Scroll half page up
<S-C-d>         → Scroll half page down
<leader>og^     → Jump to first message
<leader>og$     → Jump to last message
<leader>oA      → Cycle through agents
```

---

## Core Keybindings

### Sending Code to the AI

| Key | Mode | Action |
|-----|------|--------|
| `<leader>oa` | n, x | Ask OpenCode about the current selection/buffer (`@this:`) |
| `<leader>oo` | n, x | Open the OpenCode operations selector menu |
| `<leader>ot` | n, t | Toggle the OpenCode panel (open/close) |

### Operator Mappings (Add Range to Context)

| Key | Mode | Action |
|-----|------|--------|
| `go` | n, x | Operator: send a motion/selection to OpenCode with `@this` |
| `goo` | n | Send current line to OpenCode |

`go` works like a Vim operator: `goip` sends a paragraph, `go3j` sends 3 lines, `goiw` sends a word.

In visual mode, `go` sends the selection.

---

## Quick Prompts (Leader + `ox` namespace)

Each of these sends a pre-built prompt. They use `@this` to reference the current selection, or `@diagnostics` for LSP issues.

| Key | Prompt | Use Case |
|-----|--------|----------|
| `<leader>oxd` | `@diagnostics` | Show the AI current diagnostics |
| `<leader>oxe` | `Explain @this and its context` | Get an explanation of selected code |
| `<leader>oxf` | `Fix @diagnostics` | Ask AI to fix all diagnostics |
| `<leader>oxt` | `Add tests for @this` | Generate unit tests |
| `<leader>oxr` | `Review @this for correctness and readability` | Code review |
| `<leader>oxo` | `Optimize @this for performance and readability` | Performance improvements |
| `<leader>oxc` | `Add comments documenting @this` | Add documentation comments |
| `<leader>oxi` | `Implement @this` | Implement the selected feature/spec |

---

## Session Management

OpenCode uses sessions — each session is a conversation with the AI that maintains context history.

| Key | Action |
|-----|--------|
| `<leader>on` | Create a new, empty session |
| `<leader>os` | Select and switch to an existing session |
| `<leader>ol` | List all sessions (view/manage) |
| `<leader>osh` | Share a session (generate shareable link) |

### Session Actions (within an active session)

| Key | Action |
|-----|--------|
| `<leader>oci` | **Interrupt** — stop the AI mid-response |
| `<leader>occ` | **Compact** — compress conversation to save context |
| `<leader>ocu` | **Undo** — revert the last AI change |
| `<leader>ocr` | **Redo** — redo the last undone action |

### Session Navigation

| Key | Action |
|-----|--------|
| `<S-C-u>` | Scroll half page up in the chat buffer |
| `<S-C-d>` | Scroll half page down in the chat buffer |
| `<leader>og^` | Jump to the first message in the session |
| `<leader>og$` | Jump to the last message in the session |

### Agent Cycling

| Key | Action |
|-----|--------|
| `<leader>oA` | Cycle to the next available agent (model/provider) |

---

## Integration with Snacks Picker

When using Snacks picker (configured as a dependency), you can send picker selections directly to OpenCode:

| Key | Mode | Context | Action |
|-----|------|---------|--------|
| `<a-a>` | n, i | Inside Snacks picker | Send current selection to OpenCode |

This allows workflows like: open the file picker → search for files → press `<a-a>` to send to OpenCode for analysis.

---

## Typical Workflows

### Workflow 1: Get a code explanation

```
1. Visually select a function or block (V)
2. <leader>oxe     → Explain @this
3. Read the AI's response in the panel
```

### Workflow 2: Fix a bug

```
1. <leader>sd      → Open diagnostics (Telescope)
2. <leader>oxd     → Send diagnostics to OpenCode
3. <leader>oxf     → Ask OpenCode to fix all diagnostics
4. Review changes, <leader>ocu to undo if needed
```

### Workflow 3: Add tests

```
1. Navigate to the function you want tested
2. goo              → Send current line to OpenCode
3. <leader>oxt      → Ask OpenCode to add tests
4. Apply the suggested tests
```

### Workflow 4: Multi-step development

```
1. <leader>on       → Start a fresh session
2. <leader>oa       → Describe the feature you want
3. Wait for AI response
4. <leader>oci      → Interrupt if it goes wrong
5. <leader>ocu      → Undo changes if needed
6. <leader>occ      → Compact session to continue when context gets long
```

### Workflow 5: Code review

```
1. Open the file you want reviewed
2. <leader>oxr      → Review @this
3. Read the AI's suggestions
4. Apply changes manually or continue the conversation
```

---

## Configuration Notes

- **Autoread:** `vim.o.autoread = true` is required — ensures the buffer reloads after OpenCode modifies files.
- **Shared sessions:** `<leader>osh` can generate a shareable link for pair programming or code review with others.
- **Prompt context:** The `@this` directive includes the current selection or the current buffer content if nothing is selected. `@diagnostics` includes the current LSP diagnostics.
- **Snacks dependency:** The `snacks.nvim` plugin is used for the picker integration (optional, but configured).
