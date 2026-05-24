return {
	{
		"stevearc/aerial.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			backends = { "treesitter", "lsp" },
			layout = {
				min_width = 30,
				default_direction = "right",
			},
			-- Welche Symbole angezeigt werden
			filter_kind = {
				"Class",
				"Constructor",
				"Function",
				"Method",
				"Module",
				"Struct",
				"Interface",
			},
			-- Markdown-spezifisch: alle heading levels anzeigen
			markdown = {
				filter_kind = false, -- alle headings
			},
		},
		keys = {
			{ "]]", "<cmd>AerialNext<CR>", desc = "Next symbol" },
			{ "[[", "<cmd>AerialPrev<CR>", desc = "Prev symbol" },
			{ "<leader>a", "<cmd>AerialToggle!<CR>", desc = "Toggle Aerial outline" },
		},
	},
}
