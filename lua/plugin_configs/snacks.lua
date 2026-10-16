return {
	{
		"folke/snacks.nvim",
		lazy = false,
		---@type snacks.Config
		opts = {
			input = {},
			picker = {
				actions = {
					opencode_send = function(...)
						return require("opencode").snacks_picker_send(...)
					end,
				},
				win = {
					input = {
						keys = {
							["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
							["<Esc>"] = { "close", mode = { "n", "i" } },
						},
					},
				},
			},
		},
		config = function(_, opts)
			local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":~")

			-- Build header with wave art + cwd + prompt
			local wave = {
				[[                  ⢀       ⡤⡆⠦⠆⢀⠠                                   ]],
				[[              ⠠ ⠈     ⢤⣤⣆⢇⣶⣤⡤⡯⣦⣌⡡⠄                                ]],
				[[           ⢀⠤⠊  ⢀⣠⣾⢯⣦⣴⣜⣺⣾⣿⣤⠟⠋⣷⢛⡣⠭⠢                                ]],
				[[         ⢀⠐⠁   ⠠⣤⣿⣿⣾⣿⣿⣿⣿⣿⣿⣿⣿⣙⣷⡗⢤⡤ ⠈⣰⠶⡤                            ]],
				[[       ⢠⡔⠁      ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠑⣏⠶⡉⠖⣡⠂⣈⣤⡀                          ]],
				[[    ⣤⣤⠖⠁        ⠈⠉⢉⡻⣿⣿⣿⣿⣿⣿⣿⣿⠟⠓⠈⠅⠈  ⠘⢒⣽                            ]],
				[[ ⣿⡿⠛⠉   ⣀⠔⢀⡴⣃  ⢀⠷⠲⡄⠸⠟⢋⣿⣿⣿⣿⣿⡇   ⠐⠁  ⠂  ⠰                           ]],
				[[ ⡆⣷⣆⡐⠶⠤⢤⣷⣀⣀⣩⢐⣟⣥⠜⣤⣀⣠⣤ ⠈⠉⢀⣹⣿⣿⠃         ⠐                            ]],
				[[ ⢃⣿⣞⣫⡔⢆⡸⡿⣿⣿⣄⣰⣿⠁⢀⣛⠿⣻⣿⣿⣧⣬⣿⣿⣿⣿⡀                             ⢀   ⢀    ]],
				[[ ⢼⣿⣟⢿⣧⣾⣵⣷⣿⣿⣟⡿⢿⣶⣞⣍⡴⢿⣿⣿⣿⣿⣿⣿⣿⣿⡇                            ⢀ ⣠⠈ ⢀⣀⣼  ]],
				[[ ⠋⣿⣟⡛⢿⣿⣿⣿⣿⣿⣭⣿⣿⣿⣿⣯⣽⣿⣿⣿⣿⠟⠛⠿⢽⣿⣿⣆⡀                     ⡀⣀⢀⡠⣤⣤⣰⣿⠟⠁  ⡼⢾⣿]],
				[[ ⣻⣿⣟⣇⠈⣉⣯⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠃     ⠻⣿⣿⣿⣿⣴⣶⣤⣤⣤⣤⣴⣴⣴⣶⣦⣦⣤⣦⣀⣦⣤⣶⣿⣿⣿⣿⣿⣿⣿⠿⠁  ⡀⣤⣬⣾⣿]],
				[[ ⡝⣿⣿⣇⣤⣶⣿⣷⣾⣭⡿⠻⢿⣿⣿⣿⣿⠿⠃    ⡄   ⢊⡻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠋⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣟⢿⠟⢉ ⡀⢤⣴⣿⣿⣿⠿⠻]],
				[[ ⡁⣻⣿⣿⣿⣿⣷⣿⣿⣿⣿⠾⣿⡿⠞⠁     ⠔⠫⡅    ⠁⣀ ⠈⠻⣿⣿⣿⣿⣻⢟⣁⣄⡄⣀⠙⠻⣿⣿⡿⠿⠛⡋⠕⠂⢀⣀⣄⣓⣳⢿⠟⢛⣩⠴⠈ ]],
				[[ ⠂⡁⠈⠛⠛⠛⠛⠋⠁ ⠈⠈⡀    ⢀⠘   ⠆ ⡀⡢⣀⣆⠄⠈⠨⢦⡀⣈⠙⠛⠿⢿⣿⣿⣿⣿⣿⡿⡿⠿⠟⠆⠒⠁ ⢶⣾⠿⠟⠛⢉⣀⣠⡶⠚⠁  ⣠]],
			}

			opts.dashboard = {
				enabled = true,
				width = 70,
				preset = {
					header = table.concat(wave, "\n") .. "\n\n" .. cwd,
					keys = {
						{ icon = " ", key = "<leader>gi", desc = "Issues", action = ":Octo issue list" },
						{ icon = " ", key = "<leader>gp", desc = "PRs", action = ":Octo pr list" },
						{ icon = " ", key = "<leader>gc", desc = "Create PR", action = ":Octo pr create" },
						{ icon = " ", key = "<leader>go", desc = "Checkout PR", action = ":Octo pr checkout" },
						{ icon = " ", key = "<leader>grs", desc = "Start Review", action = ":Octo review start" },
					},
				},
				sections = {
					{ section = "header" },
					{
						section = "recent_files",
						limit = 10,
						title = "Start typing to find files. \n",
						icon = " ",
						padding = 1,
					},
					{ section = "keys", gap = 0, padding = 1 },
				},
			}

			require("snacks").setup(opts)

			vim.api.nvim_create_autocmd("User", {
				pattern = "SnacksDashboardOpened",
				callback = function()
					local buf = vim.api.nvim_get_current_buf()

					local chars = "abcdefghijklmnoprstuvwxyzABCDEFGHIJKLMNOPRSTUVWXYZ"
					for i = 1, #chars do
						local char = chars:sub(i, i)
						vim.keymap.set("n", char, function()
							require("telescope.builtin").find_files({
								default_text = char,
							})
						end, { buffer = buf, noremap = true, silent = true })
					end

					vim.keymap.set("n", "q", ":qa<CR>", { buffer = buf, noremap = true, silent = true, desc = "Quit" })
					vim.keymap.set("n", "Q", ":qa!<CR>", { buffer = buf, noremap = true, silent = true, desc = "Quit" })

					local oldfiles = vim.v.oldfiles
					local valid = {}
					for _, f in ipairs(oldfiles) do
						if vim.fn.filereadable(f) == 1 then
							table.insert(valid, f)
						end
					end
					for i = 1, 9 do
						if valid[i] then
							vim.keymap.set("n", tostring(i), function()
								vim.cmd("edit " .. vim.fn.fnameescape(valid[i]))
							end, { buffer = buf, noremap = true, silent = true })
						end
					end
					if valid[10] then
						vim.keymap.set("n", "0", function()
							vim.cmd("edit " .. vim.fn.fnameescape(valid[10]))
						end, { buffer = buf, noremap = true, silent = true })
					end
				end,
			})
		end,
	},
}
