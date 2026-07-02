-- Load core configurations
require('o0-o.remap')      -- Custom key mappings
require('o0-o.lazy_init')  -- Plugin manager setup
require('o0-o.set')        -- Editor options and settings

-- Define autocommand group for general config
local augroup = vim.api.nvim_create_augroup
local o0Group = augroup('o0-o', {})

-- Define autocommand group for yank highlighting
local yank_group = augroup('HighlightYank', {})

-- Shortcut for reloading Lua modules (useful in dev/debug)
function R(name)
    require("plenary.reload").reload_module(name)
end

-- Highlight text briefly after yanking (copying)
vim.api.nvim_create_autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

-- Automatically strip trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
    group = o0Group,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

-- LSP-specific keymaps set when a language server attaches
vim.api.nvim_create_autocmd('LspAttach', {
    group = o0Group, -- Use a named augroup to manage/clear related autocommands
    callback = function(e)
        local opts = { buffer = e.buf } -- Scope keymaps to the current buffer only (non-global)

        -- Go to definition of symbol under cursor (e.g. function, variable)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)

        -- Show hover documentation (e.g. type info, doc comments)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

        -- Search for symbols across the entire workspace/project
        vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)

        -- Show diagnostics in a floating window at cursor location
        vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)

        -- Show available code actions (e.g. quick fixes, refactorings)
        vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)

        -- Show all references to the symbol under the cursor
        vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)

        -- Rename all references to the symbol under the cursor
        vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)

        -- Show parameter signature help while typing in insert mode
        vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)

        -- Jump to next diagnostic (error/warning) in buffer
        vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)

        -- Jump to previous diagnostic in buffer
        vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
    end
})
-- Clean up trailing whitespace and extra newlines on save
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function()
        vim.cmd([[%s/\s\+$//e]])          -- Remove trailing spaces
        vim.cmd([[%s/\n\+\%$//e]])        -- Remove blank lines at end of file
    end,
})

-- Netrw appearance and behavior settings
vim.g.netrw_browse_split = 0     -- Open files in the same window
vim.g.netrw_banner = 0           -- Disable the top banner
vim.g.netrw_winsize = 25         -- Set window width to 25%

-- Configure text formatting behavior for all filetypes
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        vim.opt_local.textwidth = 72                  -- Max line length for comments
        vim.opt_local.formatoptions:remove("t")       -- Disable auto-wrapping of code
        vim.opt_local.formatoptions:append("cro")     -- Enable comment wrapping
    end,
})

-- Enable relative line numbers in netrw
vim.api.nvim_create_autocmd("FileType", {
    pattern = "netrw",
    callback = function()
        vim.wo.relativenumber = true
    end,
})

-- Automatically close netrw buffer after opening a file
vim.api.nvim_create_autocmd("BufEnter", {
    group = vim.api.nvim_create_augroup("AutoCloseNetrw", { clear = true }),
    callback = function()
        if vim.bo.filetype == "netrw" and #vim.fn.getbufinfo({ buflisted = 1 }) > 1 then
            vim.cmd("b#")       -- Switch to alternate buffer
            vim.cmd("bd #")     -- Close the previous netrw buffer
        end
    end,
})

-- Only autoformat when in insert mode and hitting return (not o in normal mode)
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        vim.opt_local.formatoptions:remove("o")
        vim.opt_local.formatoptions:append("r")
    end,
})

-- Sane tabs for lua
vim.api.nvim_create_autocmd("FileType", {
    pattern = "lua",
    callback = function()
        vim.opt_local.tabstop = 4       -- Show tabs as 4 spaces
        vim.opt_local.shiftwidth = 4    -- Indent/outdent by 4 spaces
        vim.opt_local.expandtab = true  -- Use spaces instead of actual tab characters
    end,
})

-- Compliant tabs for yaml
vim.api.nvim_create_autocmd("FileType", {
    pattern = "yaml",
    callback = function()
        vim.opt_local.tabstop = 2        -- Display tabs as 2 spaces
        vim.opt_local.shiftwidth = 2     -- Indent/outdent by 2 spaces
        vim.opt_local.expandtab = true   -- Use spaces instead of tabs
    end,
})
