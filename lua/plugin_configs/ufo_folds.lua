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

		-- Fold to level 1 on initial buffer read (once per buffer)
		vim.api.nvim_create_autocmd("BufReadPost", {
			callback = function(args)
				-- Defer to let ufo compute and apply folds first
				vim.defer_fn(function()
					if not vim.api.nvim_buf_is_valid(args.buf) then
						return
					end
					if vim.b[args.buf].ufo_initial_fold_done then
						return
					end
					vim.b[args.buf].ufo_initial_fold_done = true
					pcall(require("ufo").closeFoldsWith, 1)
				end, 200)
			end,
			group = vim.api.nvim_create_augroup("UfoInitialFold", { clear = true }),
		})

		vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
		vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
	end,
}
