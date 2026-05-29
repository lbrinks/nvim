return {
	{
		"akinsho/git-conflict.nvim",
		version = "*",
		event = "BufReadPre",
		opts = {
			default_mappings = false,
			default_commands = true,
			disable_diagnostics = true, -- less noise while resolving
			list_opener = "copen",
			highlights = {
				incoming = "DiffAdd",
				current = "DiffText",
			},
		},
		keys = {
			{ "]x", "<Plug>(git-conflict-next-conflict)", desc = "Next conflict" },
			{ "[x", "<Plug>(git-conflict-prev-conflict)", desc = "Prev conflict" },
			{ "<leader>gco", "<Plug>(git-conflict-ours)", desc = "[G]it [C]onflict: [O]urs" },
			{ "<leader>gct", "<Plug>(git-conflict-theirs)", desc = "[G]it [C]onflict: [T]heirs" },
			{ "<leader>gcb", "<Plug>(git-conflict-both)", desc = "[G]it [C]onflict: [B]oth" },
			{ "<leader>gcn", "<Plug>(git-conflict-none)", desc = "[G]it [C]onflict: [N]one" },
			{ "<leader>gcl", "<cmd>GitConflictListQf<cr>", desc = "[G]it [C]onflict: [L]ist all" },
		},
	},
}
