return {
	"vim-airline/vim-airline",
	enabled = true,

	init = function()
		-- Disable tabline integration (you're using a separate bufferline/tabline)
		vim.g["airline#extensions#tabline#enabled"] = 0

		-- Replaced by tabby
		-- vim.g["airline#extensions#tabline#show_tab_count"] = 0   -- Don't show tab count
		-- vim.g["airline#extensions#tabline#tab_nr_type"] = 2      -- Show tab numbers
		-- vim.g["airline#extensions#tabline#show_tab_type"] = 0    -- Hide "T" (tab type) indicators
		-- vim.g["airline#extensions#tabline#buffer_nr_show"] = 1   -- Show buffer numbers
		-- vim.g["airline#extensions#tabline#formatter"] = "unique_tail_improved" -- Use custom formatter for filenames

		-- Slant separators; nvim leans '/', opposite of the tmux bar's '\',
		-- to tell them apart. TTY_ASCII=1 falls back to airline's ASCII
		-- symbols (decimal escapes keep this file ASCII: U+E0BC solid out,
		-- U+E0BA solid in, U+E0BD thin slash)
		if vim.env.TTY_ASCII == '1' then
			vim.g.airline_symbols_ascii = 1
		else
			vim.g.airline_left_sep = '\238\130\188'
			vim.g.airline_right_sep = '\238\130\186'
			vim.g.airline_left_alt_sep = '\238\130\189'
			vim.g.airline_right_alt_sep = '\238\130\189'
		end

		-- Empty sections (warning/error) must not draw their separators --
		-- with solid slant glyphs they render as colored slivers at the edge
		vim.g.airline_skip_empty_sections = 1

		-- Don't show the default "-- INSERT --" etc in the command line
		vim.g.noshowmode = true -- same as `set noshowmode`
	end,

	config = function()
		-- Set up custom airline sections
		vim.g["airline_section_a"] = vim.fn["airline#section#create"]({ "mode" })          -- Mode (e.g. NORMAL)
		-- %R evaluates at draw time, so skip_empty_sections cannot drop it and an
		-- empty gray block renders; empty b for real and show RO inside c instead
		vim.g["airline_section_b"] = ""
		vim.g["airline_section_c"] = vim.fn["airline#section#create"]({ "%{&readonly ? 'RO ' : ''}%F" }) -- Readonly flag + full file path
		vim.g["airline_section_x"] = vim.fn["airline#section#create"]({ "ffenc" })         -- File format & encoding
		vim.g["airline_section_y"] = vim.fn["airline#section#create"]({ "%p%%[%L]" })      -- File position & total lines
		vim.g["airline_section_z"] = vim.fn["airline#section#create"]({ "%Y" })            -- Filetype
	end,
}
