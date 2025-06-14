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

		-- Use ASCII symbols instead of powerline-style glyphs
		vim.g.airline_symbols_ascii = 1

		-- Don't show the default "-- INSERT --" etc in the command line
		vim.g.noshowmode = true -- same as `set noshowmode`
	end,

	config = function()
		-- Set up custom airline sections
		vim.g["airline_section_a"] = vim.fn["airline#section#create"]({ "mode" })          -- Mode (e.g. NORMAL)
		vim.g["airline_section_b"] = vim.fn["airline#section#create"]({ "%R" })            -- Readonly indicator
		vim.g["airline_section_c"] = vim.fn["airline#section#create"]({ "%F" })            -- Full file path
		vim.g["airline_section_x"] = vim.fn["airline#section#create"]({ "ffenc" })         -- File format & encoding
		vim.g["airline_section_y"] = vim.fn["airline#section#create"]({ "%p%%[%L]" })      -- File position & total lines
		vim.g["airline_section_z"] = vim.fn["airline#section#create"]({ "%Y" })            -- Filetype
	end,
}
