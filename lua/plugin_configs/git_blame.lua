return {
	{
		"f-person/git-blame.nvim",
		event = "BufReadPre",
		opts = {
			enabled = false, -- start disabled, toggle on demand
			date_format = "%Y-%m-%d",
			delay = 300,
		},
		keys = {
			{ "<leader>gb", "<cmd>GitBlameToggle<cr>", desc = "[G]it [B]lame toggle" },
			{ "<leader>gB", "<cmd>Git blame<cr>", desc = "[G]it [B]lame file" },
		},
	},
}
