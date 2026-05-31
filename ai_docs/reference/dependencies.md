# Dependencies & Foundations

Plugins that other plugins depend on. They provide no direct user-facing keybindings or UI; they are libraries or infrastructure.

---

## lazy.nvim

**What:** Plugin manager. Bootstraps itself on first run, then lazily loads all other plugins.

**Who needs it:** Every other plugin. This is the entry point for the entire config.

---

## plenary.nvim

**What:** General-purpose Lua utility library for Neovim plugin developers. Provides async helpers, path manipulation, job control, testing framework, and more.

**Who needs it:** telescope.nvim, diffview.nvim, octo.nvim.

---

## nvim-web-devicons

**What:** File-type icons (nerd font required). Adds icons to the file tree, telescope results, aerial outline, octo UI, and rendered markdown code blocks.

**Who needs it:** nvim-tree.lua, telescope.nvim, aerial.nvim, octo.nvim, render-markdown.nvim.

---

## sqlite.lua

**What:** Lua bindings for SQLite. Enables persistent data storage in Neovim.

**Who needs it:** nvim-neoclip.lua — stores clipboard history across sessions.

---

## friendly-snippets

**What:** Pre-written snippet collection (LuaSnip format). Provides common code snippets for many languages.

**Who needs it:** blink.cmp — used as a completion source for snippet suggestions.

---

## promise-async

**What:** Promise/async utility for Lua. Enables asynchronous programming patterns.

**Who needs it:** nvim-ufo — used internally for async fold computation.

---

## telescope-fzf-native.nvim

**What:** Native C-based fzf sorter for Telescope. Faster and more accurate fuzzy matching than the Lua implementation.

**Who needs it:** telescope.nvim — loaded as an extension for better search sorting.

---

## nvim-treesitter

**What:** Syntax parsing framework. Powers accurate syntax highlighting, indentation, folding, and structural code navigation. Installed parsers: `c`, `lua`, `vim`, `vimdoc`, `query`, `markdown`, `markdown_inline`, `python`.

**Who needs it:** Everything that understands code structure — aerial.nvim, nvim-ufo, render-markdown.nvim, and many others. Also provides the `queries/markdown/injections.scm` to inject language-specific highlighting into fenced code blocks in markdown.

---

## lazydev.nvim

**What:** Lua LSP type support for Neovim development. Provides type definitions for the Neovim API (`vim.*`, `vim.uv`, etc.), eliminating false "undefined global" warnings in Lua config files.

**Who needs it:** nvim-lspconfig — loaded only for `lua` filetype buffers.
