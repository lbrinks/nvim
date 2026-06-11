--- Resolve GitHub token for the current environment.
--- In a coder workspace the token must be injected because /usr/bin/gh has no
--- persistent auth.  Outside coder we rely on gh's native auth.
local function resolve_gh_env()
	local coder_env = vim.env.CODER_ENVIRONMENT
	if not coder_env then
		return {}
	end
	-- Other coder environments: fetch a fresh token from the coder CLI
	local token = vim.fn.system("coder external-auth access-token primary-github"):gsub("%s+$", "")
	if vim.v.shell_error ~= 0 then
		vim.notify("[octo] Failed to fetch GitHub token via coder CLI", vim.log.levels.WARN)
		return {}
	end
	return { GITHUB_TOKEN = token }
end

local function resolve_gh_bin()
	local coder_env = vim.env.CODER_ENVIRONMENT
	if not coder_env then
		return "gh"
	end
	-- Other coder environments: fetch a fresh token from the coder CLI
	return "/usr/bin/gh"
end

--- Toggle visibility of viewed files in the file panel.
--- Stores the original files list to allow restore.
local file_panel_viewed_state = {}
local function toggle_hide_viewed_files()
	local reviews = require("octo.reviews")
	local layout = reviews.get_current_layout()
	if not layout or not layout.file_panel then
		vim.notify("[octo] No active review layout", vim.log.levels.WARN)
		return
	end

	local panel = layout.file_panel
	local tabpage = vim.api.nvim_get_current_tabpage()
	local key = tostring(tabpage)

	-- If already filtering, restore original list
	if file_panel_viewed_state[key] then
		panel.files = file_panel_viewed_state[key]
		file_panel_viewed_state[key] = nil
		vim.notify("[octo] Showing all files")
	else
		-- Save original and filter out viewed files
		file_panel_viewed_state[key] = vim.deepcopy(panel.files)
		local filtered = {}
		for _, file in ipairs(panel.files) do
			if file.viewed_state ~= "VIEWED" then
				table.insert(filtered, file)
			end
		end
		panel.files = filtered
		vim.notify(string.format("[octo] Hiding viewed files (%d unviewed)", #filtered))
	end

	-- Re-render the panel
	panel:render()
	panel:redraw()
end


return {
	{
		"pwntester/octo.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		cmd = "Octo",
		keys = {
			{ "<leader>gi", "<cmd>Octo issue list<cr>", desc = "[G]H [I]ssue list" },
			{
				"<leader>gI",
				function()
					vim.ui.input({ prompt = "Filter by label: " }, function(label)
						if label and label ~= "" then
							vim.cmd("Octo issue list labels=" .. label)
						end
					end)
				end,
				desc = "[G]H [I]ssues by label",
			},
			{ "<leader>gl", "<cmd>OctoIssueBoard<cr>", desc = "[G]H issue [L]ist buffer" },
			{ "<leader>gp", "<cmd>Octo pr list<cr>", desc = "[G]H [P]R list" },
			{ "<leader>gs", "<cmd>Octo search<cr>", desc = "[G]H [S]earch" },
			{ "<leader>gc", "<cmd>Octo pr create draft<cr>", desc = "[G]H PR [C]reate (draft)" },
			{ "<leader>gR", "<cmd>Octo pr ready<cr>", desc = "[G]H PR mark [R]eady" },
			{ "<leader>gm", "<cmd>Octo pr merge<cr>", desc = "[G]H PR [M]erge" },
			{ "<leader>grs", "<cmd>Octo review start<cr>", desc = "[G]H [R]eview [S]tart" },
			{ "<leader>grS", "<cmd>Octo review submit<cr>", desc = "[G]H [R]eview [S]ubmit" },
			{ "<leader>grr", "<cmd>Octo review resume<cr>", desc = "[G]H [R]eview [R]esume" },
			{ "<leader>grd", "<cmd>Octo review discard<cr>", desc = "[G]H [R]eview [D]iscard" },
			{ "<leader>grc", "<cmd>Octo review comments<cr>", desc = "[G]H [R]eview [C]omments" },
			{ "<leader>gk", "<cmd>Octo pr checks<cr>", desc = "[G]H PR chec[K]s" },
			{ "<leader>go", "<cmd>Octo pr checkout<cr>", desc = "[G]H PR check[O]ut" },
			{ "<leader>gd", "<cmd>Octo pr changes<cr>", desc = "[G]H PR [D]iff/changes" },
			{ "<leader>gB", "<cmd>Octo pr browser<cr>", desc = "[G]H PR [B]rowser" },
		},
		config = function()
			-- Apply wrap, linebreak, and render-markdown to Octo diff buffers for markdown files.
			-- Octo skips ftplugin triggering for these buffers, so we handle it manually.
			vim.api.nvim_create_autocmd("BufWinEnter", {
				callback = function(ev)
					local ok, props = pcall(vim.api.nvim_buf_get_var, ev.buf, "octo_diff_props")
					if not ok or not props then return end
					if not (props.path and props.path:match("%.md$")) then return end
					-- defer until after diffthis runs (which resets wrap)
					vim.schedule(function()
						local win = vim.fn.bufwinid(ev.buf)
						if win ~= -1 then
							vim.wo[win].wrap = true
							vim.wo[win].linebreak = true
						end
						if vim.bo[ev.buf].filetype == "" then
							vim.bo[ev.buf].filetype = "markdown"
						end
						pcall(function()
							require("render-markdown").buf_enable()
						end)
						-- secondary <leader>g* bindings for review diff buffers
						local b = ev.buf
						local m = require("octo.mappings")
						vim.keymap.set("n", "<leader>ge", m.focus_files, { buffer = b, desc = "focus changed files panel" })
						vim.keymap.set("n", "<leader>gb", m.toggle_files, { buffer = b, desc = "toggle changed files panel" })
						vim.keymap.set("n", "<leader>g<space>", m.toggle_viewed, { buffer = b, desc = "toggle file viewed" })
						vim.keymap.set("n", "<C-c>", "<cmd>tabclose<cr>", { buffer = b, desc = "close review tab" })
					end)
				end,
			})

			require("octo").setup({
				use_local_fs = true,
				enable_builtin = true,
				default_remote = { "upstream", "origin" },
				default_merge_method = "squash",
				ssh_aliases = {},
				picker = "telescope",
				picker_config = {
					use_emojis = false,
					mappings = {
						open_in_browser = { lhs = "<C-b>", desc = "open issue in browser" },
						copy_url = { lhs = "<C-y>", desc = "copy url to system clipboard" },
						checkout_pr = { lhs = "<C-o>", desc = "checkout pull request" },
						merge_pr = { lhs = "<C-r>", desc = "merge pull request" },
					},
				},
				comment_icon = "▎",
				outdated_icon = "󰁕 ",
				resolved_icon = " ",
				reaction_viewer_hint_icon = " ",
				user_icon = " ",
				timeline_marker = " ",
				timeline_indent = 2,
				right_bubble_delimiter = "",
				left_bubble_delimiter = "",
				snippet_context_lines = 4,
				gh_cmd = resolve_gh_bin(),
				gh_env = resolve_gh_env(),
				timeout = 5000,
				default_to_resolve_thread = false,
				ui = {
					use_signcolumn = true,
					use_signstatus = true,
				},
				issues = {
					order_by = {
						field = "CREATED_AT",
						direction = "DESC",
					},
				},
				pull_requests = {
					order_by = {
						field = "CREATED_AT",
						direction = "DESC",
					},
					always_select_remote_on_create = false,
				},
				file_panel = {
					size = 10,
				},
				colors = {
					white = "#ffffff",
					grey = "#2A354C",
					black = "#000000",
					red = "#fdb8c0",
					dark_red = "#da3633",
					green = "#acf2bd",
					dark_green = "#238636",
					yellow = "#d3c846",
					dark_yellow = "#735c0f",
					blue = "#58A6FF",
					dark_blue = "#0366d6",
					purple = "#6f42c1",
				},
				mappings_disable_default = true,
				mappings = {
					issue = {
						close_issue = { lhs = "<leader>gic", desc = "close issue" },
						reopen_issue = { lhs = "<leader>gio", desc = "reopen issue" },
						list_issues = { lhs = "<leader>gil", desc = "list open issues" },
						reload = { lhs = "<C-r>", desc = "reload issue" },
						open_in_browser = { lhs = "<C-b>", desc = "open issue in browser" },
						copy_url = { lhs = "<C-y>", desc = "copy url to clipboard" },
						add_assignee = { lhs = "<leader>gaa", desc = "add assignee" },
						remove_assignee = { lhs = "<leader>gad", desc = "remove assignee" },
						create_label = { lhs = "<leader>glc", desc = "create label" },
						add_label = { lhs = "<leader>gla", desc = "add label" },
						remove_label = { lhs = "<leader>gld", desc = "remove label" },
						add_comment = { lhs = "<leader>gca", desc = "add comment" },
						delete_comment = { lhs = "<leader>gcd", desc = "delete comment" },
						react_hooray = { lhs = "<leader>grp", desc = "add party reaction" },
						react_heart = { lhs = "<leader>grh", desc = "add heart reaction" },
						react_eyes = { lhs = "<leader>gre", desc = "add eyes reaction" },
						react_thumbs_up = { lhs = "<leader>gr+", desc = "add thumbs up reaction" },
						react_thumbs_down = { lhs = "<leader>gr-", desc = "add thumbs down reaction" },
						react_laugh = { lhs = "<leader>grl", desc = "add laugh reaction" },
						react_confused = { lhs = "<leader>grc", desc = "add confused reaction" },
					},
					pull_request = {
						checkout_pr = { lhs = "<leader>gpo", desc = "checkout PR" },
						merge_pr = { lhs = "<leader>gpm", desc = "merge PR" },
						squash_and_merge_pr = { lhs = "<leader>gps", desc = "squash and merge PR" },
						rebase_and_merge_pr = { lhs = "<leader>gpr", desc = "rebase and merge PR" },
						list_commits = { lhs = "<leader>gpc", desc = "list PR commits" },
						list_changed_files = { lhs = "<leader>gpf", desc = "list PR changed files" },
						show_pr_diff = { lhs = "<leader>gpd", desc = "show PR diff" },
						add_reviewer = { lhs = "<leader>gva", desc = "add reviewer" },
						remove_reviewer = { lhs = "<leader>gvd", desc = "remove reviewer" },
						close_issue = { lhs = "<leader>gic", desc = "close PR" },
						reopen_issue = { lhs = "<leader>gio", desc = "reopen PR" },
						reload = { lhs = "<C-r>", desc = "reload PR" },
						open_in_browser = { lhs = "<C-b>", desc = "open PR in browser" },
						copy_url = { lhs = "<C-y>", desc = "copy url to clipboard" },
						add_assignee = { lhs = "<leader>gaa", desc = "add assignee" },
						remove_assignee = { lhs = "<leader>gad", desc = "remove assignee" },
						create_label = { lhs = "<leader>glc", desc = "create label" },
						add_label = { lhs = "<leader>gla", desc = "add label" },
						remove_label = { lhs = "<leader>gld", desc = "remove label" },
						add_comment = { lhs = "<leader>gca", desc = "add comment" },
						delete_comment = { lhs = "<leader>gcd", desc = "delete comment" },
						react_hooray = { lhs = "<leader>grp", desc = "add party reaction" },
						react_heart = { lhs = "<leader>grh", desc = "add heart reaction" },
						react_eyes = { lhs = "<leader>gre", desc = "add eyes reaction" },
						react_thumbs_up = { lhs = "<leader>gr+", desc = "add thumbs up reaction" },
						react_thumbs_down = { lhs = "<leader>gr-", desc = "add thumbs down reaction" },
						react_laugh = { lhs = "<leader>grl", desc = "add laugh reaction" },
						react_confused = { lhs = "<leader>grc", desc = "add confused reaction" },
					},
				review_thread = {
					goto_issue = { lhs = "<leader>gti", desc = "navigate to issue" },
					add_comment = { lhs = "<leader>gca", desc = "add comment" },
					add_suggestion = { lhs = "<leader>gsa", desc = "add suggestion" },
					delete_comment = { lhs = "<leader>gcd", desc = "delete comment" },
					resolve_thread = { lhs = "<leader>gtr", desc = "resolve thread" },
					unresolve_thread = { lhs = "<leader>gtu", desc = "unresolve thread" },
				},
					submit_win = {
						approve_review = { lhs = "<C-a>", desc = "approve review" },
						comment_review = { lhs = "<C-m>", desc = "comment review" },
						request_changes = { lhs = "<C-r>", desc = "request changes review" },
						close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
					},
			review_diff = {
					submit_review = { lhs = "<leader>gvs", desc = "submit review" },
					discard_review = { lhs = "<leader>gvx", desc = "discard review" },
					add_review_comment = { lhs = "<localleader>c", desc = "add review comment" },
					add_review_suggestion = { lhs = "<localleader>s", desc = "add review suggestion" },
					focus_files = { lhs = "<localleader>f", desc = "focus changed files panel" },
					toggle_files = { lhs = "<localleader>b", desc = "toggle changed files panel" },
					next_thread = { lhs = "]t", desc = "move to next thread" },
					prev_thread = { lhs = "[t", desc = "move to prev thread" },
					select_next_entry = { lhs = "]q", desc = "move to next changed file" },
					select_prev_entry = { lhs = "[q", desc = "move to prev changed file" },
					select_first_entry = { lhs = "[Q", desc = "move to first changed file" },
					select_last_entry = { lhs = "]Q", desc = "move to last changed file" },
					close_review_tab = { lhs = "<localleader>q", desc = "close review tab" },
					toggle_viewed = { lhs = "<localleader>v", desc = "toggle file viewed" },
				},
				file_panel = {
					submit_review = { lhs = "<leader>gvs", desc = "submit review" },
					discard_review = { lhs = "<leader>gvx", desc = "discard review" },
					next_entry = { lhs = "", desc = "move to next changed file (use j/k)" },
					prev_entry = { lhs = "", desc = "move to prev changed file (use j/k)" },
					select_entry = { lhs = "<cr>", desc = "show selected changed file diffs" },
					refresh_files = { lhs = "R", desc = "refresh changed files panel" },
					focus_files = { lhs = "<localleader>f", desc = "focus changed files panel" },
					toggle_files = { lhs = "<localleader>b", desc = "toggle changed files panel" },
					select_next_entry = { lhs = "]q", desc = "move to next changed file" },
					select_prev_entry = { lhs = "[q", desc = "move to prev changed file" },
					select_first_entry = { lhs = "[Q", desc = "move to first changed file" },
					select_last_entry = { lhs = "]Q", desc = "move to last changed file" },
					close_review_tab = { lhs = "<localleader>q", desc = "close review tab" },
					toggle_viewed = { lhs = "<localleader><space>", desc = "toggle file viewed" },
				},
			},
			})

			-- Secondary <leader>g* bindings for review_diff and file_panel (in addition to localleader ones)
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "octo_panel" },
				callback = function(ev)
					local b = ev.buf
					local m = require("octo.mappings")
					vim.keymap.set("n", "<leader>ge", m.focus_files, { buffer = b, desc = "focus changed files panel" })
					vim.keymap.set("n", "<leader>gb", m.toggle_files, { buffer = b, desc = "toggle changed files panel" })
					vim.keymap.set("n", "<leader>g<space>", m.toggle_viewed, { buffer = b, desc = "toggle file viewed" })
					vim.keymap.set("n", "<localleader>j", m.select_next_entry, { buffer = b, desc = "move to next changed file" })
					vim.keymap.set("n", "<localleader>k", m.select_prev_entry, { buffer = b, desc = "move to prev changed file" })
					vim.keymap.set("n", "<leader>v", function()
						m.toggle_viewed()
						m.select_next_entry()
					end, { buffer = b, desc = "mark as viewed and move to next file" })
					vim.keymap.set("n", "<localleader>h", toggle_hide_viewed_files, { buffer = b, desc = "toggle hide viewed files" })
					vim.keymap.set("n", "<C-c>", "<cmd>tabclose<cr>", { buffer = b, desc = "close review tab" })
				end,
			})

			-- Extra localleader shortcuts for review threads
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "octo" },
				callback = function(ev)
					local b = ev.buf
					local m = require("octo.mappings")
					local reviews = require("octo.reviews")
					vim.keymap.set("n", "<localleader>c", m.add_comment, { buffer = b, desc = "add comment" })
					vim.keymap.set("n", "<localleader>r", m.resolve_thread, { buffer = b, desc = "resolve thread" })
					vim.keymap.set("n", "<localleader>u", m.unresolve_thread, { buffer = b, desc = "unresolve thread" })
					vim.keymap.set("n", "<localleader>rr", reviews.start_or_resume_review, { buffer = b, desc = "start or resume review" })
				end,
			})
		end,
	},
}
