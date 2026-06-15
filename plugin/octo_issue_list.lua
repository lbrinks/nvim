--- Dedicated issue list buffer for octo.nvim.
--- Opens a scratch buffer that displays GitHub issues, supports filtering by
--- label, refreshing, and opening issues directly with <cr>.

local M = {}

---@class IssueListState
---@field bufnr number|nil
---@field issues table[]
---@field filter_label string|nil
---@field repo string|nil

---@type IssueListState
local state = {
	bufnr = nil,
	issues = {},
	filter_label = nil,
	filter_assignee = nil, -- nil=no filter, string=username, ""=unassigned
	repo = nil,
}

local ns = vim.api.nvim_create_namespace("octo_issue_list")

--- Render the issue list into the buffer.
local function render()
	local buf = state.bufnr
	if not buf or not vim.api.nvim_buf_is_valid(buf) then
		return
	end

	vim.bo[buf].modifiable = true
	vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

	local lines = {}
	local header = "# Issues: " .. (state.repo or "?")
	if state.filter_label and state.filter_label ~= "" then
		header = header .. "  [label: " .. state.filter_label .. "]"
	end
	if state.filter_assignee then
		if state.filter_assignee == "" then
			header = header .. "  [assignee: none]"
		else
			header = header .. "  [assignee: " .. state.filter_assignee .. "]"
		end
	end
	table.insert(lines, header)
	table.insert(lines, string.rep("─", 60))

	if #state.issues == 0 then
		table.insert(lines, "")
		table.insert(lines, "  (no issues found)")
	else
		for _, issue in ipairs(state.issues) do
			local state_icon = issue.state == "OPEN" and "●" or "○"
			local line = string.format("  %s #%-5d %s", state_icon, issue.number, issue.title)
			table.insert(lines, line)
		end
	end

	table.insert(lines, "")
	table.insert(lines, string.rep("─", 60))
	table.insert(lines, "  r=refresh  f=label  F=clear label  a=assignee  A=clear assignee")
	table.insert(lines, "  m=mine  u=unassigned  q=close  <cr>=open  <Tab>=preview")

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].modifiable = false
end

-- Custom query that includes assignees (needed for client-side unassigned filtering)
local issues_with_assignees_query = [[
query(
  $owner: String!,
  $name: String!,
  $endCursor: String,
  $filter_by: IssueFilters,
  $order_by: IssueOrder,
) {
  repository(owner: $owner, name: $name) {
    issues(first: 100, after: $endCursor, filterBy: $filter_by, orderBy: $order_by) {
      nodes {
        __typename
        id
        number
        title
        url
        repository { nameWithOwner }
        state
        stateReason
        assignees(first: 10) {
          nodes { login }
        }
      }
      pageInfo {
        hasNextPage
        endCursor
      }
    }
  }
}
]]

--- Fetch issues from GitHub using octo's gh module.
local function fetch_issues()
	local gh = require("octo.gh")
	local config = require("octo.config")
	local utils = require("octo.utils")

	local repo = state.repo or utils.get_remote_name()
	state.repo = repo

	if not repo then
		vim.notify("[issue-list] Cannot determine repo", vim.log.levels.ERROR)
		return
	end

	local owner, name = utils.split_repo(repo)
	local cfg = config.values

	local filter_by = { states = { "OPEN" } }
	if state.filter_label and state.filter_label ~= "" then
		filter_by.labels = { state.filter_label }
	end
	-- Für "unassigned" filtern wir client-seitig (GraphQL unterstützt kein "none")
	if state.filter_assignee and state.filter_assignee ~= "" then
		filter_by.assignee = state.filter_assignee
	end

	-- Show loading state
	if state.bufnr and vim.api.nvim_buf_is_valid(state.bufnr) then
		vim.bo[state.bufnr].modifiable = true
		vim.api.nvim_buf_set_lines(state.bufnr, 0, -1, false, { "# Loading issues..." })
		vim.bo[state.bufnr].modifiable = false
	end

	gh.api.graphql({
		query = issues_with_assignees_query,
		F = {
			owner = owner,
			name = name,
			filter_by = filter_by,
			order_by = cfg.issues.order_by,
		},
		paginate = true,
		jq = ".",
		opts = {
			cb = vim.schedule_wrap(function(output, stderr)
				if stderr and stderr ~= "" then
					vim.notify("[issue-list] " .. stderr, vim.log.levels.ERROR)
					return
				end
				if not output or output == "" then
					state.issues = {}
					render()
					return
				end
				local ok, resp = pcall(utils.aggregate_pages, output, "data.repository.issues.nodes")
				if ok and resp and resp.data and resp.data.repository then
					local issues = resp.data.repository.issues.nodes or {}
					-- Client-side filter: unassigned
					if state.filter_assignee == "" then
						local filtered = {}
						for _, issue in ipairs(issues) do
							local has_assignees = issue.assignees
								and issue.assignees.nodes
								and #issue.assignees.nodes > 0
							if not has_assignees then
								table.insert(filtered, issue)
							end
						end
						issues = filtered
					end
					state.issues = issues
				else
					state.issues = {}
				end
				render()
			end),
		},
	})
end

--- Get the issue number on the current cursor line.
---@return number|nil
local function get_issue_at_cursor()
	local line = vim.api.nvim_get_current_line()
	local num = line:match("#(%d+)")
	return num and tonumber(num) or nil
end

--- Set up buffer-local keymaps.
local function setup_keymaps(buf)
	local opts = { buffer = buf, nowait = true, silent = true }

	-- Open issue under cursor
	vim.keymap.set("n", "<cr>", function()
		local num = get_issue_at_cursor()
		if num then
			-- Reuse existing right split or create one
			local list_win = vim.api.nvim_get_current_win()
			local target_win = nil

			for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
				if win ~= list_win then
					local pos = vim.api.nvim_win_get_position(win)
					local list_pos = vim.api.nvim_win_get_position(list_win)
					-- Window to the right of the issue list
					if pos[2] > list_pos[2] then
						target_win = win
						break
					end
				end
			end

			if target_win then
				vim.api.nvim_set_current_win(target_win)
			else
				vim.cmd("vsplit")
			end
			vim.cmd("Octo issue edit " .. num .. " " .. state.repo)
		end
	end, vim.tbl_extend("force", opts, { desc = "Open issue" }))

	-- Preview issue in right split without leaving the list
	vim.keymap.set("n", "<Tab>", function()
		local num = get_issue_at_cursor()
		if num then
			local list_win = vim.api.nvim_get_current_win()
			local target_win = nil

			for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
				if win ~= list_win then
					local pos = vim.api.nvim_win_get_position(win)
					local list_pos = vim.api.nvim_win_get_position(list_win)
					if pos[2] > list_pos[2] then
						target_win = win
						break
					end
				end
			end

			if target_win then
				vim.api.nvim_set_current_win(target_win)
			else
				vim.cmd("vsplit")
			end
			vim.cmd("Octo issue edit " .. num .. " " .. state.repo)
			-- Return focus to the issue list
			vim.api.nvim_set_current_win(list_win)
		end
	end, vim.tbl_extend("force", opts, { desc = "Preview issue" }))

	-- Refresh
	vim.keymap.set("n", "r", function()
		fetch_issues()
	end, vim.tbl_extend("force", opts, { desc = "Refresh issues" }))

	-- Filter by label (Telescope picker with repo labels)
	vim.keymap.set("n", "f", function()
		local gh = require("octo.gh")
		local queries = require("octo.gh.queries")
		local octo_utils = require("octo.utils")
		local pickers = require("telescope.pickers")
		local finders = require("telescope.finders")
		local conf = require("telescope.config").values
		local actions = require("telescope.actions")
		local action_state = require("telescope.actions.state")

		local repo = state.repo or octo_utils.get_remote_name()
		if not repo then
			vim.notify("[issue-list] Cannot determine repo", vim.log.levels.ERROR)
			return
		end
		local owner, name = octo_utils.split_repo(repo)

		gh.api.graphql({
			query = queries.labels,
			F = { owner = owner, name = name },
			jq = ".data.repository.labels.nodes",
			opts = {
				cb = vim.schedule_wrap(function(output, stderr)
					if stderr and stderr ~= "" then
						vim.notify("[issue-list] " .. stderr, vim.log.levels.ERROR)
						return
					end
					if not output or output == "" then
						vim.notify("[issue-list] No labels found", vim.log.levels.WARN)
						return
					end
					local ok, labels = pcall(vim.json.decode, output)
					if not ok or not labels then
						vim.notify("[issue-list] Failed to parse labels", vim.log.levels.ERROR)
						return
					end

					pickers
						.new({}, {
							prompt_title = "Filter by label",
							finder = finders.new_table({
								results = labels,
								entry_maker = function(label)
									return {
										value = label,
										display = label.name,
										ordinal = label.name,
									}
								end,
							}),
							sorter = conf.generic_sorter({}),
							attach_mappings = function(prompt_bufnr)
								actions.select_default:replace(function()
									local selection = action_state.get_selected_entry()
									actions.close(prompt_bufnr)
									if selection then
										state.filter_label = selection.value.name
										fetch_issues()
									end
								end)
								return true
							end,
						})
						:find()
				end),
			},
		})
	end, vim.tbl_extend("force", opts, { desc = "Filter by label" }))

	-- Clear label filter
	vim.keymap.set("n", "F", function()
		state.filter_label = nil
		fetch_issues()
	end, vim.tbl_extend("force", opts, { desc = "Clear label filter" }))

	-- Assigned to me
	vim.keymap.set("n", "m", function()
		if not vim.g.octo_viewer then
			vim.g.octo_viewer = require("octo.gh").get_user_name()
		end
		state.filter_assignee = vim.g.octo_viewer
		if not state.filter_assignee then
			vim.notify("[issue-list] Could not determine GitHub username", vim.log.levels.ERROR)
			return
		end
		fetch_issues()
	end, vim.tbl_extend("force", opts, { desc = "Assigned to me" }))

	-- Unassigned
	vim.keymap.set("n", "u", function()
		state.filter_assignee = ""
		fetch_issues()
	end, vim.tbl_extend("force", opts, { desc = "Unassigned issues" }))

	-- Filter by assignee (Telescope picker with repo collaborators)
	vim.keymap.set("n", "a", function()
		local gh = require("octo.gh")
		local queries = require("octo.gh.queries")
		local octo_utils = require("octo.utils")
		local pickers = require("telescope.pickers")
		local finders = require("telescope.finders")
		local conf = require("telescope.config").values
		local actions = require("telescope.actions")
		local action_state = require("telescope.actions.state")

		local repo = state.repo or octo_utils.get_remote_name()
		if not repo then
			vim.notify("[issue-list] Cannot determine repo", vim.log.levels.ERROR)
			return
		end
		local owner, name = octo_utils.split_repo(repo)

		gh.api.graphql({
			query = queries.assignable_users,
			F = { owner = owner, name = name },
			jq = ".data.repository.assignableUsers.nodes",
			opts = {
				cb = vim.schedule_wrap(function(output, stderr)
					if stderr and stderr ~= "" then
						vim.notify("[issue-list] " .. stderr, vim.log.levels.ERROR)
						return
					end
					if not output or output == "" then
						vim.notify("[issue-list] No assignable users found", vim.log.levels.WARN)
						return
					end
					local ok, users = pcall(vim.json.decode, output)
					if not ok or not users then
						vim.notify("[issue-list] Failed to parse users", vim.log.levels.ERROR)
						return
					end

					pickers
						.new({}, {
							prompt_title = "Filter by assignee",
							finder = finders.new_table({
								results = users,
								entry_maker = function(user)
									local display = user.login
									if user.name and user.name ~= "" then
										display = display .. " (" .. user.name .. ")"
									end
									return {
										value = user,
										display = display,
										ordinal = user.login .. " " .. (user.name or ""),
									}
								end,
							}),
							sorter = conf.generic_sorter({}),
							attach_mappings = function(prompt_bufnr)
								actions.select_default:replace(function()
									local selection = action_state.get_selected_entry()
									actions.close(prompt_bufnr)
									if selection then
										state.filter_assignee = selection.value.login
										fetch_issues()
									end
								end)
								return true
							end,
						})
						:find()
				end),
			},
		})
	end, vim.tbl_extend("force", opts, { desc = "Filter by assignee" }))

	-- Clear assignee filter
	vim.keymap.set("n", "A", function()
		state.filter_assignee = nil
		fetch_issues()
	end, vim.tbl_extend("force", opts, { desc = "Clear assignee filter" }))

	-- Close
	vim.keymap.set("n", "q", function()
		vim.api.nvim_buf_delete(buf, { force = true })
		state.bufnr = nil
	end, vim.tbl_extend("force", opts, { desc = "Close issue list" }))
end

--- Open or focus the issue list buffer.
function M.open()
	-- Reuse existing buffer if still valid
	if state.bufnr and vim.api.nvim_buf_is_valid(state.bufnr) then
		-- Find window showing the buffer, or open in current window
		local wins = vim.fn.win_findbuf(state.bufnr)
		if #wins > 0 then
			vim.api.nvim_set_current_win(wins[1])
		else
			vim.api.nvim_set_current_buf(state.bufnr)
		end
		return
	end

	-- Create scratch buffer
	local buf = vim.api.nvim_create_buf(true, true)
	state.bufnr = buf

	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].bufhidden = "hide"
	vim.bo[buf].swapfile = false
	vim.bo[buf].filetype = "octo_issue_list"
	vim.api.nvim_buf_set_name(buf, "GitHub Issues")

	setup_keymaps(buf)
	vim.api.nvim_set_current_buf(buf)
	fetch_issues()
end

--- Create user command and keymap
vim.api.nvim_create_user_command("OctoIssueBoard", function()
	M.open()
end, { desc = "Open persistent GitHub issue list buffer" })

return M
