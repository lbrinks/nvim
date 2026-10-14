return {
	{ -- Adds git releated signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
			current_line_blame = true,
			on_attach = function(bufnr)
				local gs = require("gitsigns")
				vim.keymap.set("n", "<leader>gb", gs.toggle_current_line_blame, {
					buffer = bufnr,
					desc = "[G]it [B]lame toggle",
				})
			end,
		},
	},
}
