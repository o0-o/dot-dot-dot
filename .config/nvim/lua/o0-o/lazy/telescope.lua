return {
	"nvim-telescope/telescope.nvim",
	enabled = true,

	-- Use a tagged stable release
	tag = "0.1.5",

	-- Required dependency
	dependencies = {
		"nvim-lua/plenary.nvim"
	},

	config = function()
		-- Initialize Telescope with default settings
		require('telescope').setup({})

		local builtin = require('telescope.builtin')

		-- <leader>pf — Find files in project using Telescope's file picker
		vim.keymap.set('n', '<leader>pf', builtin.find_files, {})

		-- <C-p> — Search Git-tracked files
		vim.keymap.set('n', '<C-p>', builtin.git_files, {})

		-- <leader>pws — Grep for the word under the cursor (word, no punctuation)
		vim.keymap.set('n', '<leader>pws', function()
			local word = vim.fn.expand("<cword>")
			builtin.grep_string({ search = word })
		end)

		-- <leader>pWs — Grep for WORD under cursor (includes punctuation, e.g. `foo.bar`)
		vim.keymap.set('n', '<leader>pWs', function()
			local word = vim.fn.expand("<cWORD>")
			builtin.grep_string({ search = word })
		end)

		-- <leader>ps — Prompt user for input, then grep for that string
		vim.keymap.set('n', '<leader>ps', function()
			builtin.grep_string({ search = vim.fn.input("Grep > ") })
		end)

		-- <leader>vh — Search Neovim help tags
		vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
	end
}
