return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local harpoon = require("harpoon")
			harpoon:setup()

			vim.keymap.set("n", "<leader>ha", function()
				harpoon:list():add()
			end, { desc = "[H]arpoon [A]dd file" })

			vim.keymap.set("n", "<leader>sm", function()
				local telescope = require("telescope")
				telescope.extensions.harpoon.marks()
			end, { desc = "[S]earch Harpoon [M]arks" })
		end,
	},
}
