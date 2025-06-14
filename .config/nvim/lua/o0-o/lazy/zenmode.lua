return {
    "folke/zen-mode.nvim",  -- Distraction-free coding mode
    enabled = true,
    config = function()
        local zen_mode = require("zen-mode")

        -- Track Zen toggle state: 0 = normal, 1 = minimal, 2 = full
        local zen_state = 0

        -- Shared function to apply visual tweaks
        local function apply_visuals(minimal)
            vim.wo.wrap = false
            vim.opt.colorcolumn = minimal and "80" or "0"

            if minimal then
                vim.wo.number = true
                vim.wo.rnu = true
            else
                vim.wo.number = false
                vim.wo.rnu = false
            end
        end

        -- Main toggle function
        vim.keymap.set("n", "<leader>z", function()
            if zen_state == 0 then
                -- 1️⃣ Minimal Zen
                zen_mode.setup({
                    window = {
                        width = 90,
                        options = {},
                    },
                })
                zen_mode.open()
                apply_visuals(true)
                zen_state = 1

            elseif zen_state == 1 then
                -- 2️⃣ Full Zen
                zen_mode.setup({
                    window = {
                        width = 80,
                        options = {},
                    },
                })
                zen_mode.open()
                apply_visuals(false)
                zen_state = 2

            else
                -- 3️⃣ Back to Normal Mode
                zen_mode.close()
                vim.opt.colorcolumn = "80"
                vim.wo.number = true
                vim.wo.rnu = true
                zen_state = 0
            end
        end, { desc = "Cycle Zen Mode: Normal → Minimal → Full → Normal" })
    end
}
