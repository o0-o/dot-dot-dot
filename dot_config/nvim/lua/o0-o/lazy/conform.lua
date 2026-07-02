return {
    -- Formatter plugin that supports async formatting with LSP or external tools
    'stevearc/conform.nvim',
    enabled = true,

    -- Optional top-level opts (empty here but can be used for global settings)
    opts = {},

    config = function()
        require("conform").setup({
            -- Configure formatters for specific filetypes
            formatters_by_ft = {
                -- Use "stylua" to format Lua files
                lua = { "stylua" },
            }
        })
    end
}
