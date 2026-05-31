# Markdown & LaTeX

Plugins for working with markup and academic documents.

---

## render-markdown.nvim — Markdown Preview

**What:** Renders markdown in real-time within the buffer: styled headings, bordered code blocks, formatted tables, checkboxes, block quotes, and callouts. Uses Treesitter to parse the markdown syntax, then overlays graphical decorations without modifying the actual text.

### Keybindings

| Key | Action |
|-----|--------|
| `<leader>mr` | Toggle rendering on/off |
| `<leader>mR` | Enable rendering |
| `<leader>mM` | Disable rendering |
| `<leader>mp` | Open preview in a new buffer |

### What Gets Rendered

| Element | Style |
|---------|-------|
| **Headings** | Icons (`󰲡`–`󰲫`), colored backgrounds, over/underlines |
| **Code blocks** | Bordered boxes, language name on top-left, inline code styling |
| **Tables** | Rounded corner borders, padded cells, alignment arrows |
| **Bullet lists** | Level icons: `● ○ ◆ ◇` |
| **Checkboxes** | `󰄱` (unchecked), `󰱒` (checked) |
| **Block quotes** | Left border bar (`▋`) with up to 6 nesting levels |
| **Links** | Icons for hyperlinks, images, emails, wiki links, GitHub/Neovim links |
| **Callouts** | GitHub-style alerts: Note (`󰋽`), Tip (`󰌶`), Important (`󰅾`), Warning (`󰀪`), Caution (`󰳦`) |
| **Horizontal rules** | Full-width line (`─`) |
| **LaTeX math** | Converted to UTF-8 text (`utftex` + `latex2text`) |

### Anti-Conceal

On the cursor line, concealed characters (like `#` markers on headings, or ` ``` ` on code blocks) are revealed as virtual text so you can still edit the raw markdown.

### Performance

- Debounced at 100ms to avoid lag during edits.
- Only updates on `BufWritePost` (lazy rendering).
- Disabled for files larger than 10MB.

### Custom Treesitter Injections

The file `queries/markdown/injections.scm` patches the default markdown injections to prevent a Treesitter parsing bug. Fenced code blocks, HTML blocks, YAML/TOML frontmatter, and inline markdown are injected correctly.

---

## vimtex — LaTeX Support

**What:** Comprehensive LaTeX plugin: syntax highlighting, compilation, forward/backward search, folding, and completion. Configured for Skim as the PDF viewer.

### Configuration

- **PDF viewer:** Skim (macOS)
- **Quickfix:** Closes automatically after keystrokes; opens only on errors (not warnings)
- **Folding:** Enabled for sections, environments

### Typical Workflow

1. Edit `.tex` file — vimtex provides syntax highlighting, indentation, and environment completion.
2. `\ll` — compile the document (vimtex default mapping)
3. `\lv` — view the PDF (opens in Skim, supports SyncTeX forward search)
4. `\le` — open and parse compilation errors in quickfix

---

## vim-textidote — Grammar Checking

**What:** Grammar and style checker for LaTeX (and plain text) documents. Integrates with `textidote` (a Java-based tool). Runs `:Textidote` to check the current file.

**Usage:** `:Textidote` — requires `textidote.jar` installed on the system.
