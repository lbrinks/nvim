local set = vim.opt
local bind = vim.keymap.set

vim.g.mapleader = " " -- set leader key
vim.g.maplocalleader = "\\" -- set local leader
set.linebreak = true -- Prevents words from breaking over line
set.breakindent = true -- Indent wrapped lines
set.fileencoding = "utf-8" -- The encoding written to file
set.ruler = true -- Show the cursor position all the time
set.expandtab = true -- Converts tabs to spaces
set.tabstop = 2 -- Insert 2 spaces for a tab
set.shiftwidth = 2 -- Change the space characters inserted for indentation
set.smarttab = true -- Makes tabbing smarter will realize you have 2 vs 4
set.autoindent = true -- Good auto indent
set.number = true -- Line numbers
set.relativenumber = true -- Relative Line numbers
set.hidden = true -- Required to keep multiple buffers open multiple buffers
set.hlsearch = false -- Set highlight on search
vim.o.mouse = "a" -- Enable mouse mode
vim.o.undofile = true -- Save undo history
vim.o.ignorecase = true -- Case insensitive searching UNLESS /C or capital in search
vim.o.updatetime = 250 -- Decrease update time
vim.wo.signcolumn = "yes"
vim.o.termguicolors = true
vim.o.incsearch = true
vim.o.wildmode = "longest,list"
vim.o.smartcase = true
set.splitright = true
set.splitbelow = true

-- [[ Highlight on yank ]]
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
})

bind("i", "jk", "<Esc>")
bind("n", "Y", "y$")
bind("v", ">", ">gv")
bind("v", "<", "<gv")
bind("v", "jk", "<Esc>")
bind("n", "<leader>w", ":w<CR>")
bind("n", "<leader>W", ":wq<CR>")
bind("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
bind("n", "<leader>Q", ":q!<CR>")
bind("n", "<leader>b", ":NvimTreeFocus<CR>")
bind("n", "<C-b>", ":NvimTreeToggle<CR>")
bind("i", "<C-b>", ":NvimTreeToggle<CR>")

-- terminal mode
bind("t", "<Esc>", "<C-\\><C-n>")
bind("t", "jk", "<C-\\><C-n>")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {
		{ import = "plugin_configs" },
		"EdenEast/nightfox.nvim", -- colorscheme
		"tpope/vim-surround", -- changes the surround of motions
		"tpope/vim-fugitive", -- use :G to use git from the vim command line
		"tpope/vim-repeat", -- repeat stuff!
		"numToStr/Comment.nvim", -- "gc" to comment visual regions/lines
		"tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
		"christoomey/vim-tmux-navigator", -- nvim & tmux integration and movement
		{ -- Add indentation guides even on blank lines
			"lukas-reineke/indent-blankline.nvim",
			config = function()
				require("ibl").setup({})
			end,
		},
	},
})
vim.cmd("colorscheme terafox")
