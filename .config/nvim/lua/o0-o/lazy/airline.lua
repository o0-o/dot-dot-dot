return {
	"vim-airline/vim-airline",
	init = function()
		-- Set g: variables early so Airline sees them on load
		vim.g["airline#extensions#tabline#enabled"] = 1
		vim.g["airline#extensions#tabline#show_tab_count"] = 0
		vim.g["airline#extensions#tabline#tab_nr_type"] = 2
		vim.g["airline#extensions#tabline#show_tab_type"] = 0
		vim.g["airline#extensions#tabline#buffer_nr_show"] = 1
		vim.g["airline#extensions#tabline#formatter"] = "unique_tail_improved"
		vim.g.airline_symbols_ascii = 1
		vim.g.noshowmode = true -- same as `set noshowmode`
	end,
	config = function()
		vim.g["airline_section_a"] = vim.fn["airline#section#create"]({ "mode" })
		vim.g["airline_section_b"] = vim.fn["airline#section#create"]({ "%R" })
		vim.g["airline_section_c"] = vim.fn["airline#section#create"]({ "%F" })
		vim.g["airline_section_x"] = vim.fn["airline#section#create"]({ "ffenc" })
		vim.g["airline_section_y"] = vim.fn["airline#section#create"]({ "%p%%[%L]" })
		vim.g["airline_section_z"] = vim.fn["airline#section#create"]({ "%Y" })
	end,
}
