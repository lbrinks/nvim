return {
	{
		"sindrets/diffview.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
		keys = {
			{ "<leader>dv", "<cmd>DiffviewOpen<cr>", desc = "[D]iff[V]iew open" },
			{ "<leader>dc", "<cmd>DiffviewClose<cr>", desc = "[D]iffview [C]lose" },
			{ "<leader>dh", "<cmd>DiffviewFileHistory %<cr>", desc = "[D]iffview file [H]istory" },
			{ "<leader>dH", "<cmd>DiffviewFileHistory<cr>", desc = "[D]iffview branch [H]istory" },
			{ "<leader>dm", "<cmd>DiffviewOpen HEAD<cr>", desc = "[D]iffview [M]erge conflicts" },
		},
		opts = {
			enhanced_diff_hl = true,
			use_icons = true,
			view = {
				default = {
					layout = "diff2_horizontal",
				},
				merge_tool = {
					layout = "diff3_mixed",
					disable_diagnostics = true,
				},
				file_history = {
					layout = "diff2_horizontal",
				},
			},
			file_panel = {
				listing_style = "tree",
				tree_options = {
					flatten_dirs = true,
					folder_statuses = "only_folded",
				},
				win_config = {
					position = "left",
					width = 35,
				},
			},
			hooks = {
				diff_buf_read = function(_)
					vim.opt_local.wrap = false
					vim.opt_local.list = false
				end,
			},
			keymaps = {
				view = {
					{ "n", "<leader>ge", "<cmd>DiffviewFocusFiles<cr>", { desc = "Focus file panel" } },
					{ "n", "<leader>gb", "<cmd>DiffviewToggleFiles<cr>", { desc = "Toggle file panel" } },
					{ "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
				},
				file_panel = {
					{ "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
				},
				file_history_panel = {
					{ "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
				},
			},
		},
	},
}
