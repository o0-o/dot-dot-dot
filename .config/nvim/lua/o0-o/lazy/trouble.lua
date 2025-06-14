return {
	{
		"folke/trouble.nvim", -- A pretty diagnostics, references, quickfix and location list UI
		enabled = true,

		config = function()
			require("trouble").setup({
				icons = false, -- Disable icons for a simpler look (can be set to true if preferred)
			})

			-- Toggle the Trouble window with <leader>tt
			vim.keymap.set("n", "<leader>tt", function()
				require("trouble").toggle()
			end, { desc = "Trouble: Toggle window" })

			-- Jump to the next Trouble item (skipping groups)
			vim.keymap.set("n", "[t", function()
				require("trouble").next({ skip_groups = true, jump = true })
			end, { desc = "Trouble: Next item" })

			-- Jump to the previous Trouble item (skipping groups)
			vim.keymap.set("n", "]t", function()
				require("trouble").previous({ skip_groups = true, jump = true })
			end, { desc = "Trouble: Previous item" })
		end
	},
}
