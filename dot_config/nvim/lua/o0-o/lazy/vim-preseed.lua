return {
	"git.netizen.se/vim-preseed",                 -- Vim plugin for syntax highlighting and support for Debian preseed files
	enabled = true,
	url = "ssh://anonymous@git.netizen.se/vim-preseed", -- Clone via SSH from external git server (no GitHub)
	branch = "main",                               -- Use the main branch
	ft = "preseed",                                -- Load plugin only for files detected as filetype 'preseed'
}
