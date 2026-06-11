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
				vim.notify("Harpoon: added " .. vim.fn.expand("%:p"), vim.log.levels.INFO)
			end, { desc = "[H]arpoon [A]dd file" })

			vim.keymap.set("n", "<leader>sm", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end, { desc = "[S]earch Harpoon [M]arks" })

			vim.keymap.set("n", "<leader>1", function()
				harpoon:list():select(1)
			end, { desc = "Harpoon mark 1" })
			vim.keymap.set("n", "<leader>2", function()
				harpoon:list():select(2)
			end, { desc = "Harpoon mark 2" })
			vim.keymap.set("n", "<leader>3", function()
				harpoon:list():select(3)
			end, { desc = "Harpoon mark 3" })
			vim.keymap.set("n", "<leader>4", function()
				harpoon:list():select(4)
			end, { desc = "Harpoon mark 4" })
		end,
	},
}
