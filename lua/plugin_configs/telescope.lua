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

			local function harpoon_add_action(prompt_bufnr)
				local action_state = require("telescope.actions.state")
				local entry = action_state.get_selected_entry()
				if entry then
					local path = entry.filename or entry.path or entry[1]
					local item = {
						value = path,
						context = { row = entry.lnum or 1, col = entry.col or 0 },
					}
					require("harpoon"):list():add(item)
					vim.schedule(function()
						vim.notify("Harpoon: added " .. path, vim.log.levels.INFO)
					end)
				end
			end

			-- [[ Configure Telescope ]]
			require("telescope").setup({
				defaults = {
					file_ignore_patterns = { ".git/", ".venv" },
					mappings = {
						i = { ["<C-h>"] = harpoon_add_action },
						n = { ["<C-h>"] = harpoon_add_action },
					},
				},
				pickers = {
					help_tags = {
						mappings = {
							i = {
								["<CR>"] = "file_vsplit",
							},
						},
					},
					find_files = {
						-- Boost .py files by sorting them before .rst in tiebreaker
						tiebreak = function(entry_a, entry_b)
							local a_py = entry_a.ordinal:match("%.py$") and true or false
							local a_rst = entry_a.ordinal:match("%.rst$") and true or false
							local b_py = entry_b.ordinal:match("%.py$") and true or false
							local b_rst = entry_b.ordinal:match("%.rst$") and true or false
							-- .py wins over non-.py
							if a_py and not b_py then
								return true
							end
							if b_py and not a_py then
								return false
							end
							-- .rst loses to non-.rst
							if a_rst and not b_rst then
								return false
							end
							if b_rst and not a_rst then
								return true
							end
							-- Fallback: alphabetical
							return entry_a.ordinal < entry_b.ordinal
						end,
					},
				},
			})

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
			bind("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })
			bind("n", "<leader>sc", function()
				require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
			end, { desc = "[S]earch [C]onfig Files" })
			bind("n", "<leader>sp", ":Telescope neoclip <CR>", { desc = "[S]earch [P]aste Registers" })
		end,
	},
}
