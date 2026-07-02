return {
    {
        "L3MON4D3/LuaSnip", -- Snippet engine for Neovim
        enabled = true,

        -- Use latest v2.* version (stable release)
        version = "v2.*",

        -- Install optional JS regex engine for advanced snippet support
        build = "make install_jsregexp",

        -- Load community-maintained snippets for many languages
        dependencies = { "rafamadriz/friendly-snippets" },

        config = function()
            local ls = require("luasnip")

            -- Enable jsdoc snippets inside JavaScript files
            ls.filetype_extend("javascript", { "jsdoc" })

            -- Use <Tab> to expand or jump to the next placeholder if available
            vim.keymap.set({ "i", "s" }, "<Tab>", function()
                if ls.expand_or_jumpable() then
                    return "<Plug>luasnip-expand-or-jump"
                else
                    return "<Tab>"
                end
            end, { expr = true, silent = true })

            -- Use <S-Tab> to jump to the previous placeholder if available
            vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
                if ls.jumpable(-1) then
                    return "<Plug>luasnip-jump-prev"
                else
                    return "<S-Tab>"
                end
            end, { expr = true, silent = true })

            -- Use <C-l> to cycle through choices in a choiceNode (if active)
            vim.keymap.set({ "i", "s" }, "<C-l>", function()
                if ls.choice_active() then
                    ls.change_choice(1)
                end
            end, { silent = true })
        end,
    }
}
