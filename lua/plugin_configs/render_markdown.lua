---@module 'render-markdown'
---@type render.md.UserConfig

return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		opts = {
			-- Enabled by default, toggle with `:RenderMarkdown toggle`
			enabled = true,

			-- Modes where markdown is rendered
			render_modes = { "n", "c", "t" },

			-- Debounce updates to avoid lag during rapid edits
			debounce = 100,

			-- Update frequency for lazy rendering
			change_events = { "BufWritePost" },

			-- Maximum file size (MB) to render
			max_file_size = 10.0,

			-- Preset configuration (obsidian, lazy, none)
			preset = "none",

			-- Anti-conceal: show virtual text on cursor line
			anti_conceal = {
				enabled = true,
				above = 0,
				below = 0,
				ignore = {
					code_background = true,
					indent = true,
					sign = true,
					virtual_lines = true,
				},
			},

			-- Heading configuration
			heading = {
				enabled = true,
				sign = true,
				position = "overlay",
				icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
				width = "full",
				left_margin = 0,
				left_pad = 0,
				right_pad = 0,
				min_width = 0,
				border = false,
				above = "▄",
				below = "▀",
				backgrounds = {
					"RenderMarkdownH1Bg",
					"RenderMarkdownH2Bg",
					"RenderMarkdownH3Bg",
					"RenderMarkdownH4Bg",
					"RenderMarkdownH5Bg",
					"RenderMarkdownH6Bg",
				},
				foregrounds = {
					"RenderMarkdownH1",
					"RenderMarkdownH2",
					"RenderMarkdownH3",
					"RenderMarkdownH4",
					"RenderMarkdownH5",
					"RenderMarkdownH6",
				},
			},

			-- Code block configuration - the main issue with fenced blocks
			code = {
				enabled = true,
				sign = true,
				-- Conceal ``` markers at top and bottom
				conceal_delimiters = true,
				language = true,
				language_icon = true,
				language_name = true,
				language_info = true,
				position = "left",
				language_pad = 0,
				-- Disable rendering for these languages if needed
				disable = {},
				-- Don't disable background for any language by default
				disable_background = {},
				background_inset = 1,
				width = "full",
				left_margin = 0,
				left_pad = 0,
				right_pad = 0,
				min_width = 0,
				-- Thin border around code blocks
				border = "thin",
				language_border = "█",
				language_left = "",
				language_right = "",
				above = "▄",
				below = "▀",
				-- Inline code styling
				inline = true,
				inline_left = "",
				inline_right = "",
				inline_pad = 0,
				priority = 140,
				highlight = "RenderMarkdownCode",
				highlight_info = "RenderMarkdownCodeInfo",
				highlight_language = nil,
				highlight_border = "RenderMarkdownCodeBorder",
				highlight_fallback = "RenderMarkdownCodeFallback",
				highlight_inline = "RenderMarkdownCodeInline",
				-- Full rendering style for code blocks
				style = "full",
			},

			-- Bullet list styling
			bullet = {
				enabled = true,
				-- Use different icons for nesting levels
				icons = { "●", "○", "◆", "◇" },
				left_pad = 0,
				right_pad = 0,
				highlight = "RenderMarkdownBullet",
			},

			-- Checkbox styling (for task lists)
			checkbox = {
				enabled = true,
				bullet = false,
				left_pad = 0,
				right_pad = 1,
				unchecked = {
					icon = "󰄱 ",
					highlight = "RenderMarkdownUnchecked",
					scope_highlight = nil,
				},
				checked = {
					icon = "󰱒 ",
					highlight = "RenderMarkdownChecked",
					scope_highlight = nil,
				},
			},

			-- Block quotes
			quote = {
				enabled = true,
				icon = "▋",
				repeat_linebreak = false,
				highlight = {
					"RenderMarkdownQuote1",
					"RenderMarkdownQuote2",
					"RenderMarkdownQuote3",
					"RenderMarkdownQuote4",
					"RenderMarkdownQuote5",
					"RenderMarkdownQuote6",
				},
			},

			-- Pipe tables (GFM syntax with |)
			pipe_table = {
				enabled = true,
				preset = "none",
				-- Use padded cells for better alignment
				cell = "padded",
				padding = 1,
				min_width = 0,
				-- Round corner table borders
				border = {
					"┌",
					"┬",
					"┐",
					"├",
					"┼",
					"┤",
					"└",
					"┴",
					"┘",
					"│",
					"─",
				},
				border_enabled = true,
				border_virtual = false,
				alignment_indicator = "━",
				head = "RenderMarkdownTableHead",
				row = "RenderMarkdownTableRow",
				style = "full",
			},

			-- Thematic breaks (horizontal rules)
			dash = {
				enabled = true,
				icon = "─",
				width = "full",
				left_margin = 0,
				highlight = "RenderMarkdownDash",
			},

			-- Links and images
			link = {
				enabled = true,
				footnote = {
					enabled = true,
					icon = "󰯔 ",
					superscript = true,
					prefix = "",
					suffix = "",
				},
				image = "󰥶 ",
				email = "󰀓 ",
				hyperlink = "󰌹 ",
				highlight = "RenderMarkdownLink",
				highlight_title = "RenderMarkdownLinkTitle",
				wiki = {
					enabled = true,
					icon = "󱗖 ",
					conceal_destination = true,
					highlight = "RenderMarkdownWikiLink",
				},
				custom = {
					web = { icon = "󰖟 ", pattern = "^http" },
					github = { icon = "󰊤 ", pattern = "github%.com", kind = "url" },
					neovim = { icon = " ", pattern = "neovim%.io", kind = "url" },
				},
			},

			-- Callouts (like GitHub alerts)
			callout = {
				note = { raw = "[!NOTE]", rendered = "󰋽 Note", highlight = "RenderMarkdownInfo" },
				tip = { raw = "[!TIP]", rendered = "󰌶 Tip", highlight = "RenderMarkdownSuccess" },
				important = {
					raw = "[!IMPORTANT]",
					rendered = "󰅾 Important",
					highlight = "RenderMarkdownHint",
				},
				warning = { raw = "[!WARNING]", rendered = "󰀪 Warning", highlight = "RenderMarkdownWarn" },
				caution = { raw = "[!CAUTION]", rendered = "󰳦 Caution", highlight = "RenderMarkdownError" },
			},

			-- LaTeX support (if you use math)
			latex = {
				enabled = true,
				render_modes = false,
				converter = { "utftex", "latex2text" },
				highlight = "RenderMarkdownMath",
				position = "center",
				top_pad = 0,
				bottom_pad = 0,
			},

			-- Paragraph rendering
			paragraph = {
				enabled = true,
				left_margin = 0,
				indent = 0,
				min_width = 0,
			},

			-- Window options (conceallevel when rendering)
			win_options = {
				conceallevel = {
					default = vim.o.conceallevel,
					rendered = 3,
				},
				concealcursor = {
					default = vim.o.concealcursor,
					rendered = "",
				},
			},
		},
		config = function(_, opts)
			require("render-markdown").setup(opts)

			-- Optional: Add custom keybindings for render-markdown commands
			local map = vim.keymap.set
			local opts_silent = { noremap = true, silent = true }

			-- Toggle markdown rendering
			map("n", "<leader>mr", "<cmd>RenderMarkdown toggle<cr>", opts_silent)

			-- Enable rendering
			map("n", "<leader>mR", "<cmd>RenderMarkdown enable<cr>", opts_silent)

			-- Disable rendering
			map("n", "<leader>mM", "<cmd>RenderMarkdown disable<cr>", opts_silent)

			-- View rendered markdown in preview
			map("n", "<leader>mp", "<cmd>RenderMarkdown preview<cr>", opts_silent)
		end,
	},
}
