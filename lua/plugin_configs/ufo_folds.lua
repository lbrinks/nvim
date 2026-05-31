return {
	"kevinhwang91/nvim-ufo",
	dependencies = { "kevinhwang91/promise-async" },
	config = function()
		vim.opt.foldmethod = "manual"
		vim.opt.foldenable = true
		vim.opt.foldlevel = 99
		vim.opt.foldlevelstart = 99

		require("ufo").setup({
			provider_selector = function()
				return { "treesitter" }
			end,
		})

		vim.keymap.set("n", "zz", function()
			if vim.wo.foldlevel >= 99 then
				pcall(require("ufo").closeFoldsWith, 1)
			else
				require("ufo").openAllFolds()
			end
		end, { desc = "Toggle folds" })

		vim.keymap.set("n", "zo", "zO", { remap = true, desc = "Open all folds under cursor" })
		vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
		vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
	end,
}
