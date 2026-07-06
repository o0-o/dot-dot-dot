return {
	"nanozuki/tabby.nvim",
	enabled = true,
	config = function()

		-- Always show the tabline (0 = never, 1 = only if >1 tab, 2 = always)
		vim.o.showtabline = 2

		-- Slant glyphs shared with the tmux status bar motif; TTY_ASCII=1
		-- forces the ASCII fallbacks (decimal escapes keep this file ASCII)
		-- nvim leans '/', opposite of the tmux bar's '\', to tell them apart
		local ascii = vim.env.TTY_ASCII == '1'
		local slant_in  = ascii and '/' or '\238\130\186' -- U+E0BA solid slant in
		local slant_out = ascii and '/' or '\238\130\188' -- U+E0BC solid slant out
		local thin      = ascii and '/' or '\238\130\189' -- U+E0BD thin slash

		-- Function to define the layout and appearance of the tabline
		local components = function()
			local result = {
				-- Left spacer (make even with tmux panel title)
				{
					type = 'text',
					text = { '  ', hl = 'TabLineFill' },
				},
			}

			local cur_buf = vim.api.nvim_get_current_buf() -- Get current buffer

			-- Listed, valid buffers form the ribbon
			local bufs = {}
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted then
					table.insert(bufs, buf)
				end
			end

			for i, buf in ipairs(bufs) do
				local current = buf == cur_buf
				local modified = vim.bo[buf].modified

				-- Leading boundary: solid edges open the band and bracket the
				-- current buffer; background-colored thin slashes divide the rest
				local glyph, hl
				if i == 1 then
					glyph, hl = slant_in, current and 'TabLineSelEdgeOuter' or 'TabLineEdge'
				elseif current then
					glyph, hl = slant_in, 'TabLineSelEdge'
				elseif bufs[i - 1] == cur_buf then
					glyph, hl = slant_out, 'TabLineSelEdge'
				else
					glyph, hl = thin, 'TabLineThin'
				end
				table.insert(result, { type = 'text', text = { glyph, hl = hl } })

				-- Segment: bold names, italic when modified, white block when current
				local seg_hl
				if current then
					seg_hl = modified and 'TabLineSelMod' or 'TabLineSel'
				else
					seg_hl = modified and 'TabLineMod' or 'TabLine'
				end

				-- Extract just the filename (tail) from full path
				local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ':t')

				-- Add buffer segment: " N: filename "
				table.insert(result, {
					type = 'text',
					text = {
						string.format(' %d: %s ', buf, name),
						hl = seg_hl,
					},
				})
			end

			-- Close the band
			if #bufs > 0 then
				table.insert(result, {
					type = 'text',
					text = {
						slant_out,
						hl = bufs[#bufs] == cur_buf and 'TabLineSelEdgeOuter' or 'TabLineEdge',
					},
				})
			end

			-- Right spacer
			table.insert(result, {
				type = 'text',
				text = {
					' ',
					hl = 'TabLineFill',
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
