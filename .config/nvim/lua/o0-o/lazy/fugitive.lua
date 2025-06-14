return {
    "tpope/vim-fugitive", -- Git integration plugin for Vim/Neovim
    enabled = true,
    config = function()
        -- Map <leader>gs to open the Fugitive Git status window
        vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "Fugitive: Git status" })

        -- Create an augroup to contain fugitive-related autocmds
        local o0Fugitive = vim.api.nvim_create_augroup("o0Fugitive", {})

        -- Autocmd to define keymaps when inside a Fugitive buffer
        local autocmd = vim.api.nvim_create_autocmd
        autocmd("BufWinEnter", {
            group = o0Fugitive,
            pattern = "*",
            callback = function()
                -- Only apply if the buffer is a Fugitive window
                if vim.bo.ft ~= "fugitive" then
                    return
                end

                local bufnr = vim.api.nvim_get_current_buf()
                local opts = { buffer = bufnr, remap = false }

                -- Push current branch to remote
                vim.keymap.set("n", "<leader>p", function()
                    vim.cmd.Git("push")
                end, opts)

                -- Pull with rebase
                vim.keymap.set("n", "<leader>P", function()
                    vim.cmd.Git({ "pull", "--rebase" })
                end, opts)

                -- Set upstream tracking (e.g. `:Git push -u origin my-branch`)
                vim.keymap.set("n", "<leader>t", ":Git push -u origin ", opts)
            end,
        })

        -- Diff mode merge conflict resolution
        -- Accept changes from the left (base branch, usually "ours")
        vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>", { desc = "Diffget: take left/base (ours)" })

        -- Accept changes from the right (incoming branch, usually "theirs")
        vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>", { desc = "Diffget: take right/incoming (theirs)" })
    end
}
