return {
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "ruff_organize_imports", "ruff_fix", "ruff_format" },
			},
			format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
			default_format_opts = { lsp_format = "fallback" },
		},
	},
}
