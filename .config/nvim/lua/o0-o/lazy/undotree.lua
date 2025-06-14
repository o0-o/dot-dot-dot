return {
    "mbbill/undotree", -- Visualize and browse Vim undo history as a tree
    enabled = true,

    config = function()
        -- <leader>u: Toggle the undo tree window
        vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "UndoTree: Toggle" })
    end
}
