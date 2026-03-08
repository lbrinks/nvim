return {
	{ -- LaTeX plugins
		"lervag/vimtex",
		config = function()
			vim.g.vimtex_quickfix_open_on_warning = 0
			vim.g.vimtex_quickfix_autoclose_after_keystrokes = 1
			vim.g.vimtex_view_method = "zathura"
			vim.g.vimtex_fold_enabled = true
		end,
	},
	{ "PatrBal/vim-textidote" },
}
