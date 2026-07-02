return {
	"echasnovski/mini.hipatterns", -- Plugin for custom inline pattern highlighting (e.g., bold, italic in comments)
	enabled = true,
	version = false,               -- Use latest git version (not tagged releases)
	event = "VeryLazy",            -- Lazy load on idle

	config = function()
		local hipatterns = require("mini.hipatterns")

		-- Helper: Only match patterns inside comments (syntax group name contains "comment")
		local function comment_only(pattern)
			return function(match)
				local syn_id = vim.fn.synID(match.from_line + 1, match.from_col + 1, true)
				local syn_name = vim.fn.synIDattr(syn_id, "name")
				return syn_name:lower():find("comment")
			end
		end

		hipatterns.setup({
			highlighters = {
				-- Bold: Match **bold** style text inside comments
				bold = {
					pattern = "%*%*.-%*%*", -- Match text between double asterisks
					group = "MiniHipatternsBold",
					condition = comment_only("%*%*.-%*%*"),
				},

				-- Italic: Match _italic_ style text inside comments
				italic = {
					pattern = "%f[%w_]_%w.-_%f[%W_]", -- Word surrounded by underscores
					group = "MiniHipatternsItalic",
					condition = comment_only("%f[%w_]_%w.-_%f[%W_]"),
				},

				-- Strikethrough: Match ~~strike~~ style text inside comments
				strikethrough = {
					pattern = "~~.-~~",
					group = "MiniHipatternsStrike",
					condition = comment_only("~~.-~~"),
				},

				-- Inline Code: Match `inline code` style in comments
				inline_code = {
					pattern = "`.-`",
					group = "MiniHipatternsCode",
					condition = comment_only("`.-`"),
				},
			},
		})

		-- Highlight groups for the above patterns
		vim.api.nvim_set_hl(0, "MiniHipatternsBold", { bold = true })
		vim.api.nvim_set_hl(0, "MiniHipatternsItalic", { italic = true })
		vim.api.nvim_set_hl(0, "MiniHipatternsStrike", { strikethrough = true })
		vim.api.nvim_set_hl(0, "MiniHipatternsCode", { bg = "#2A2C4D", nocombine = true })
	end,
}
