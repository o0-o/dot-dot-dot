return {
    {
        "toppair/peek.nvim",
        enabled = true,
        event = { "VeryLazy" },
        build = "deno task --quiet build:fast",
        config = function()
            -- Setup Peek with desired filetypes
            require("peek").setup({
                filetype = { 'markdown', 'conf' }
            })

            -- Define user commands :PeekOpen and :PeekClose (still available manually)
            vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
            vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})

            -- Toggle markdown preview with <leader>mp
            vim.keymap.set("n", "<leader>mp", function()
                if require("peek").is_open() then
                    require("peek").close()
                else
                    require("peek").open()
                end
            end, { desc = "Markdown Preview: Toggle" })

        end,
    },
}
