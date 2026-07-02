return {
    "nvim-neotest/neotest", -- Core testing framework for Neovim with pluggable adapters
    enabled = true,
    dependencies = {
        "nvim-neotest/nvim-nio",                 -- Required async library
        "nvim-lua/plenary.nvim",                 -- Common utility functions
        "antoinemadec/FixCursorHold.nvim",       -- Fixes CursorHold event delays (needed for test output)
        "nvim-treesitter/nvim-treesitter",       -- Tree-sitter integration for test parsing
        "fredrikaverpil/neotest-golang",         -- Adapter for Go test integration
        "leoluz/nvim-dap-go",                    -- DAP (debug adapter) for Go
    },
    config = function()
        -- Setup neotest with Go adapter
        require("neotest").setup({
            adapters = {
                require("neotest-golang")({
                    dap = { justMyCode = false }, -- Allow stepping through external packages in DAP
                }),
            },
        })

        -- Run nearest test (non-suite), using Testify integration
        vim.keymap.set("n", "<leader>tr", function()
            require("neotest").run.run({
                suite = false,
                testify = true,
            })
        end, { desc = "Debug: Running Nearest Test" })

        -- Toggle the test summary UI pane
        vim.keymap.set("n", "<leader>tv", function()
            require("neotest").summary.toggle()
        end, { desc = "Debug: Summary Toggle" })

        -- Run the entire test suite with Testify
        vim.keymap.set("n", "<leader>ts", function()
            require("neotest").run.run({
                suite = true,
                testify = true,
            })
        end, { desc = "Debug: Running Test Suite" })

        -- Debug the nearest test using DAP (launches debugger)
        vim.keymap.set("n", "<leader>td", function()
            require("neotest").run.run({
                suite = false,
                testify = true,
                strategy = "dap", -- Run using debug adapter
            })
        end, { desc = "Debug: Debug Nearest Test" })

        -- Open the test output window (last test run)
        vim.keymap.set("n", "<leader>to", function()
            require("neotest").output.open()
        end, { desc = "Debug: Open test output" })

        -- Run all tests in the current working directory
        vim.keymap.set("n", "<leader>ta", function()
            require("neotest").run.run(vim.fn.getcwd())
        end, { desc = "Debug: Run all tests in cwd" })
    end
}
