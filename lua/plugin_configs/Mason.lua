return {
	{
		"mason-org/mason-lspconfig.nvim",
		opts = { ensure_installed = { "basedpyright", "bashls" } },
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			{
				"neovim/nvim-lspconfig",
				dependencies = { -- gets rid of the vim global undefined, hopefully
					"folke/lazydev.nvim",
					ft = "lua", -- only load on lua files
					opts = {
						library = {
							-- See the configuration section for more details
							-- Load luvit types when the `vim.uv` word is found
							{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
						},
					},
				},
			},
		},
	},
}
