-- Line numbering
vim.opt.nu = true                         -- Show absolute line number
vim.opt.relativenumber = true            -- Show relative line numbers

-- Cursor line highlight
vim.opt.cursorline = true                -- Highlight the current line

-- Smart indentation
vim.opt.smartindent = true               -- Automatically insert indents in some cases

-- File backup and undo settings
vim.opt.swapfile = false                 -- Disable swap files
vim.opt.backup = false                   -- Disable backup files
vim.opt.undodir = os.getenv('HOME') .. '/.local/share/nvim/undodir' -- Set undo file directory
vim.opt.undofile = true                  -- Enable persistent undo

-- Search behavior
vim.opt.hlsearch = false                 -- Don't highlight matches after search
vim.opt.incsearch = true                 -- Show match while typing search

-- Terminal colors
vim.opt.termguicolors = true            -- Enable 24-bit RGB color

-- Scrolling and gutter
vim.opt.scrolloff = 8                    -- Keep 8 lines visible above/below cursor
vim.opt.signcolumn = 'yes'              -- Always show the sign column

-- Filename character set
vim.opt.isfname:append('@-@')            -- Allow @ characters in filenames
-- (Specifically, this makes '@' and '-' treated as part of a filename when jumping or expanding filenames)

-- Performance
vim.opt.updatetime = 50                  -- Faster completion & cursor hold events (default is 4000ms)

-- Ruler guide
vim.opt.colorcolumn = '80'              -- Highlight the 80th column

-- Enable modelines
vim.opt.modeline = true                 -- Allow file-specific settings at the top/bottom of files

-- Encoding
vim.opt.encoding = "utf-8"              -- Set default encoding to UTF-8

-- Filetype and syntax
vim.cmd("filetype plugin on")           -- Enable filetype detection and filetype-specific plugins
vim.cmd("syntax on")                    -- Enable syntax highlighting

-- Termguicolors safety check
if vim.fn.has("termguicolors") == 1 then
	vim.opt.termguicolors = true
end

-- Visual wrapping
vim.opt.showbreak = "↪"                 -- Character shown before wrapped lines

-- Whitespace visibility
vim.opt.list = true                     -- Show invisible characters
vim.opt.listchars = "space:·,trail:·,tab:│ " -- Define characters for whitespace indicators

-- Mouse
vim.opt.mouse = "a"                     -- Enable mouse support in all modes

-- Status line
vim.opt.laststatus = 2                  -- Always show the status line

-- Mode display
vim.opt.showmode = false                -- Don't show default mode text like "-- INSERT --"

-- Completion behavior
vim.opt.wildmode = "longest,list,full"  -- Configure command-line completion behavior

-- Window split behavior (replicate tmux)
vim.opt.splitbelow = true               -- Open horizontal splits below
vim.opt.splitright = true               -- Open vertical splits to the right
