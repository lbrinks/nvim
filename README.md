# Neovim config

Personal Neovim configuration, managed with [lazy.nvim](https://github.com/folke/lazy.nvim) and [Mason](https://github.com/mason-org/mason.nvim). Detailed notes on every plugin live in [`ai_docs/reference/`](ai_docs/reference/).

## Setup

Clone (or init the submodule) into `~/.config/nvim`, then run the bootstrap script to install the system prerequisites:

```sh
git clone git@github.com:lbrinks/nvim.git ~/.config/nvim
~/.config/nvim/scripts/bootstrap.sh
nvim
```

The first `nvim` launch installs the plugins (lazy.nvim), language servers (Mason), and tree-sitter parsers automatically.

## System prerequisites

`scripts/bootstrap.sh` checks for and installs the following on **Arch Linux** (via `yay`, falling back to `pacman`) or **macOS** (via Homebrew):

| Tool | Arch package | brew formula |
|------|--------------|--------------|
| node | `nodejs` | `node` |
| npm | `npm` | `node` (bundled) |
| tree-sitter CLI | `tree-sitter-cli` | `tree-sitter-cli` |
| ripgrep | `ripgrep` | `ripgrep` |
| fd | `fd` | `fd` |

The script is idempotent — it only installs what is missing and skips tools already on `PATH`.

### Assumed to be present

These are **not** installed by the script:

| Tool | Needed for | Arch | macOS |
|------|------------|------|-------|
| `git` | lazy.nvim bootstrapping | `git` | preinstalled |
| `python3` | Mason `basedpyright`, `after/ftplugin/python.lua` | `python` | `python` |
| `make` + C compiler | `telescope-fzf-native` build, tree-sitter parser compilation | `base-devel` | `xcode-select --install` |
