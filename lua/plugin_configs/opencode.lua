-- OpenCode Neovim Integration
-- Bridge Neovim and OpenCode AI agent
-- GitHub: https://github.com/nickjvandyke/opencode.nvim

return {
	{
		"nickjvandyke/opencode.nvim",
		version = "*", -- Latest stable release
		dependencies = {
			"folke/snacks.nvim",
		},
		config = function()
			-- Configuration for opencode.nvim
			---@type opencode.Opts
			vim.g.opencode_opts = {
				-- OpenCode server configuration
				-- The plugin will try to find an existing opencode instance,
				-- or start one in an embedded terminal
			}

			vim.o.autoread = true -- Required for opts.events.reload

			-- Explicitly define keybindings for easy customization
			local map = vim.keymap.set

			-- Core navigation
			map({ "n", "x" }, "<leader>oa", function()
				require("opencode").ask("@this: ", { submit = true })
			end, { desc = "Ask OpenCode" })

			map({ "n", "x" }, "<leader>oo", function()
				require("opencode").select()
			end, { desc = "OpenCode operations" })

			map({ "n", "t" }, "<leader>ot", function()
				require("opencode").toggle()
			end, { desc = "Toggle OpenCode" })

			-- Operator mappings for ranges and selections
			map({ "n", "x" }, "go", function()
				return require("opencode").operator("@this ")
			end, { desc = "Add range to OpenCode", expr = true })

			map("n", "goo", function()
				return require("opencode").operator("@this ") .. "_"
			end, { desc = "Add line to OpenCode", expr = true })

			-- Session control
			map("n", "<leader>ol", function()
				require("opencode").command("session.list")
			end, { desc = "List OpenCode sessions" })

			map("n", "<leader>on", function()
				require("opencode").command("session.new")
			end, { desc = "New OpenCode session" })

			map("n", "<leader>os", function()
				require("opencode").command("session.select")
			end, { desc = "Select OpenCode session" })

			map("n", "<leader>osh", function()
				require("opencode").command("session.share")
			end, { desc = "Share OpenCode session" })

			-- Session actions
			map("n", "<leader>oci", function()
				require("opencode").command("session.interrupt")
			end, { desc = "Interrupt OpenCode session" })

			map("n", "<leader>occ", function()
				require("opencode").command("session.compact")
			end, { desc = "Compact OpenCode session" })

			map("n", "<leader>ocu", function()
				require("opencode").command("session.undo")
			end, { desc = "Undo OpenCode action" })

			map("n", "<leader>ocr", function()
				require("opencode").command("session.redo")
			end, { desc = "Redo OpenCode action" })

			-- Navigation in session
			map("n", "<S-C-u>", function()
				require("opencode").command("session.half.page.up")
			end, { desc = "Scroll OpenCode up" })

			map("n", "<S-C-d>", function()
				require("opencode").command("session.half.page.down")
			end, { desc = "Scroll OpenCode down" })

			map("n", "<leader>og^", function()
				require("opencode").command("session.first")
			end, { desc = "Jump to first OpenCode message" })

			map("n", "<leader>og$", function()
				require("opencode").command("session.last")
			end, { desc = "Jump to last OpenCode message" })

			-- Agent cycling
			map("n", "<leader>oA", function()
				require("opencode").command("agent.cycle")
			end, { desc = "Cycle OpenCode agent" })

			-- Quick prompts using available prompt library
			map("n", "<leader>oxd", function()
				require("opencode").prompt("@diagnostics")
			end, { desc = "Ask OpenCode about diagnostics" })

			map("n", "<leader>oxe", function()
				require("opencode").prompt("Explain @this and its context")
			end, { desc = "Ask OpenCode to explain" })

			map("n", "<leader>oxf", function()
				require("opencode").prompt("Fix @diagnostics")
			end, { desc = "Ask OpenCode to fix" })

			map("n", "<leader>oxt", function()
				require("opencode").prompt("Add tests for @this")
			end, { desc = "Ask OpenCode for tests" })

			map("n", "<leader>oxr", function()
				require("opencode").prompt("Review @this for correctness and readability")
			end, { desc = "Ask OpenCode to review" })

			map("n", "<leader>oxo", function()
				require("opencode").prompt("Optimize @this for performance and readability")
			end, { desc = "Ask OpenCode to optimize" })

			map("n", "<leader>oxc", function()
				require("opencode").prompt("Add comments documenting @this")
			end, { desc = "Ask OpenCode to document" })

			map("n", "<leader>oxi", function()
				require("opencode").prompt("Implement @this")
			end, { desc = "Ask OpenCode to implement" })

			-- Alternative to <C-a> and <C-x> if you prefer leader-based
			map("n", "+", "<C-a>", { desc = "Increment", noremap = true })
			map("n", "-", "<C-x>", { desc = "Decrement", noremap = true })
		end,
	},
}
