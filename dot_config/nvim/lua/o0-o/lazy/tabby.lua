return {
	"nanozuki/tabby.nvim",
	enabled = true,
	config = function()

		-- Always show the tabline (0 = never, 1 = only if >1 tab, 2 = always)
		vim.o.showtabline = 2

		-- Function to define the layout and appearance of the tabline
		local components = function()
			local result = {
				-- Left spacer (make even with tmux panel title)
				{
					type = 'text',
					text = { '  ', hl = 'TabLine' },
				},
			}

			local cur_buf = vim.api.nvim_get_current_buf() -- Get current buffer

			-- Iterate over all buffers
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				-- Only show listed and valid buffers
				if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted then
					local hl
					local modified = vim.bo[buf].modified

					-- Determine appropriate highlight group based on active status and modified state
					if buf == cur_buf then
						hl = modified and 'TabLineSelMod' or 'TabLineSel' -- current buffer
					else
						hl = modified and 'TabLineMod' or 'TabLine'       -- other buffers
					end

					-- Extract just the filename (tail) from full path
					local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ':t')

					-- Add buffer tab entry: " N: filename "
					table.insert(result, {
						type = 'text',
						text = {
							string.format(' %d: %s ', buf, name),
							hl = hl,
						},
					})
				end
			end

			-- Right spacer
			table.insert(result, {
				type = 'text',
				text = {
					' ',
					hl = 'TabLine',
				},
			})

			return result
		end

		-- Set up tabby with the custom components
		require('tabby').setup({
			components = components,
		})
	end,
}
