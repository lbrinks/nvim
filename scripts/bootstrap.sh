#!/usr/bin/env bash
#
# bootstrap.sh - install the system prerequisites for this Neovim config.
#
# Scope: node, npm, tree-sitter-cli, ripgrep, fd.
# Supported platforms: Arch Linux (yay, falling back to pacman) and macOS (Homebrew).
#
# NOT installed by this script (assumed to be present already):
#   git                  - lazy.nvim clones itself/plugins with git (init.lua)
#   python3              - mason installs basedpyright; after/ftplugin/python.lua
#   make + a C compiler  - telescope-fzf-native (build = "make") and nvim-treesitter
#                          parser compilation. Arch: base-devel; macOS: xcode-select --install
#
# Usage:
#   ./scripts/bootstrap.sh
#
set -euo pipefail

info() { printf '\033[34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[33mwarning:\033[0m %s\n' "$*" >&2; }
die() { printf '\033[31merror:\033[0m %s\n' "$*" >&2; exit 1; }

# command | arch package | brew formula
TOOLS=(
	"node|nodejs|node"
	"npm|npm|node"
	"tree-sitter|tree-sitter-cli|tree-sitter-cli"
	"rg|ripgrep|ripgrep"
	"fd|fd|fd"
)

platform=""
install_cmd=()

case "$(uname -s)" in
Linux)
	os_id=""
	if [[ -r /etc/os-release ]]; then
		# shellcheck disable=SC1091
		os_id="$(. /etc/os-release && printf '%s %s' "${ID:-}" "${ID_LIKE:-}")"
	fi
	[[ "$os_id" == *arch* ]] || die "unsupported Linux distribution: this script targets Arch Linux"

	platform="arch"
	if command -v yay >/dev/null 2>&1; then
		install_cmd=(yay -S --needed)
	elif command -v pacman >/dev/null 2>&1; then
		install_cmd=(sudo pacman -S --needed)
	else
		die "neither 'yay' nor 'pacman' was found on PATH"
	fi
	;;
Darwin)
	command -v brew >/dev/null 2>&1 || die "Homebrew not found; install it from https://brew.sh first"
	platform="brew"
	install_cmd=(brew install)
	;;
*)
	die "unsupported OS: $(uname -s)"
	;;
esac

present=""
missing=""
seen=" "

for entry in "${TOOLS[@]}"; do
	IFS='|' read -r cmd arch_pkg brew_pkg <<<"$entry"
	if [[ "$platform" == "arch" ]]; then
		pkg="$arch_pkg"
	else
		pkg="$brew_pkg"
	fi

	if command -v "$cmd" >/dev/null 2>&1; then
		present="$present $cmd"
		continue
	fi

	# Dedupe packages (npm and node both map to "node" on macOS).
	case "$seen" in
	*" $pkg "*) continue ;;
	esac
	seen="$seen$pkg "
	missing="$missing $pkg"
done

if [[ -n "$present" ]]; then
	info "already installed:$present"
fi

if [[ -z "$missing" ]]; then
	info "all prerequisites are satisfied"
	exit 0
fi

info "installing:$missing"
"${install_cmd[@]}" $missing

info "verifying installation"
failed=0
for entry in "${TOOLS[@]}"; do
	IFS='|' read -r cmd _ _ <<<"$entry"
	if command -v "$cmd" >/dev/null 2>&1; then
		info "ok: $cmd -> $(command -v "$cmd")"
	else
		warn "'$cmd' is still not on PATH"
		failed=1
	fi
done

if [[ "$failed" -ne 0 ]]; then
	die "some prerequisites could not be verified"
fi

info "done - launch nvim to let lazy.nvim and Mason install the rest"
