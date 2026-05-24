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
			{ "<leader>gp", "<cmd>Octo pr list<cr>", desc = "[G]H [P]R list" },
			{ "<leader>gs", "<cmd>Octo search<cr>", desc = "[G]H [S]earch" },
			{ "<leader>gc", "<cmd>Octo pr create<cr>", desc = "[G]H PR [C]reate" },
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
			require("octo").setup({
				use_local_fs = false,
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
				mappings_disable_default = false,
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
						react_rocket = { lhs = "<leader>grr", desc = "add rocket reaction" },
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
						react_rocket = { lhs = "<leader>grr", desc = "add rocket reaction" },
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
						add_review_comment = { lhs = "<leader>gca", desc = "add review comment" },
						add_review_suggestion = { lhs = "<leader>gsa", desc = "add review suggestion" },
						focus_files = { lhs = "<leader>ge", desc = "focus changed files panel" },
						toggle_files = { lhs = "<leader>gb", desc = "toggle changed files panel" },
						next_thread = { lhs = "]t", desc = "move to next thread" },
						prev_thread = { lhs = "[t", desc = "move to prev thread" },
						select_next_entry = { lhs = "]q", desc = "move to next changed file" },
						select_prev_entry = { lhs = "[q", desc = "move to prev changed file" },
						select_first_entry = { lhs = "[Q", desc = "move to first changed file" },
						select_last_entry = { lhs = "]Q", desc = "move to last changed file" },
						close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
						toggle_viewed = { lhs = "<leader>g<space>", desc = "toggle file viewed" },
					},
					file_panel = {
						submit_review = { lhs = "<leader>gvs", desc = "submit review" },
						discard_review = { lhs = "<leader>gvx", desc = "discard review" },
						next_entry = { lhs = "j", desc = "move to next changed file" },
						prev_entry = { lhs = "k", desc = "move to prev changed file" },
						select_entry = { lhs = "<cr>", desc = "show selected changed file diffs" },
						refresh_files = { lhs = "R", desc = "refresh changed files panel" },
						focus_files = { lhs = "<leader>ge", desc = "focus changed files panel" },
						toggle_files = { lhs = "<leader>gb", desc = "toggle changed files panel" },
						select_next_entry = { lhs = "]q", desc = "move to next changed file" },
						select_prev_entry = { lhs = "[q", desc = "move to prev changed file" },
						select_first_entry = { lhs = "[Q", desc = "move to first changed file" },
						select_last_entry = { lhs = "]Q", desc = "move to last changed file" },
						close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
						toggle_viewed = { lhs = "<leader>g<space>", desc = "toggle file viewed" },
					},
				},
			})
		end,
	},
}
