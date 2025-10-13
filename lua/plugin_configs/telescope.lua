return {
	{
		"nvim-telescope/telescope.nvim",
		version = "*",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		config = function()
			local bind = vim.keymap.set
			-- [[ Configure Telescope ]]
			require("telescope").setup({})

			-- Enable telescope fzf native, if installed
			require("telescope").load_extension("fzf")
			--
			-- Telescope keymaps
			bind("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
			bind("n", "<leader><space>", require("telescope.builtin").buffers, { desc = "[ ] Find existing buffers" })
			bind("n", "<leader>sf", function()
				require("telescope.builtin").find_files({ hidden = true })
			end, { desc = "[S]earch [F]iles" })
			bind("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
			bind("n", "<leader>sw", require("telescope.builtin").grep_string, { desc = "[S]earch current [W]ord" })
			bind("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
			bind("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]ekarch [D]iagnostics" })
			bind("n", "<leader>sc", function()
				require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
			end, { desc = "[S]earch [C]onfig Files" })
			bind("n", "<leader>sp", ":Telescope neoclip <CR>", { desc = "[S]earch [P]aste Registers" })
		end,
	},
}
