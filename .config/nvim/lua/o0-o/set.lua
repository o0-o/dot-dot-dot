vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

vim.opt.smartindent = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv('HOME') .. '/.local/share/nvim/undodir'
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = 'yes'
vim.opt.isfname:append('@-@') -- TODO: what is this?

vim.opt.updatetime = 50

vim.opt.colorcolumn = '80'

-- Allow modelines
vim.opt.modeline = true

-- Encoding
vim.opt.encoding = "utf-8"

-- Filetype detection and plugins
vim.cmd("filetype plugin on")

-- Syntax highlighting
vim.cmd("syntax on")

-- Use 24-bit color if supported
if vim.fn.has("termguicolors") == 1 then
	vim.opt.termguicolors = true
end

-- Showbreak character for wrapped lines
vim.opt.showbreak = "↪"

-- Whitespace indicators
vim.opt.list = true
vim.opt.listchars = "space:·,trail:·,tab:│ "

-- Enable mouse in all modes
vim.opt.mouse = "a"

-- Always show status line
vim.opt.laststatus = 2

-- Hide default mode display (e.g. -- INSERT --)
vim.opt.showmode = false

-- Count underscores as word separators (i.e., not part of word)
vim.opt.iskeyword:remove("_")

-- Autocompletion behavior
vim.opt.wildmode = "longest,list,full"

-- Window split behavior
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Enable setting terminal title
vim.opt.title = true
