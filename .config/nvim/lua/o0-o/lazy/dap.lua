-- Create a new autocommand group for all DAP-related autocmds
vim.api.nvim_create_augroup("DapGroup", { clear = true })

-- This function focuses the window that contains a specific buffer (used for DAP REPL or watches)
local function navigate(args)
    local buffer = args.buf
    local wid = nil
    local win_ids = vim.api.nvim_list_wins() -- Get all window IDs

    -- Find the window displaying the given buffer
    for _, win_id in ipairs(win_ids) do
        local win_bufnr = vim.api.nvim_win_get_buf(win_id)
        if win_bufnr == buffer then
            wid = win_id
        end
    end

    if wid == nil then
        return -- Do nothing if window not found
    end

    -- Schedule window focus (must be done in a safe async context)
    vim.schedule(function()
        if vim.api.nvim_win_is_valid(wid) then
            vim.api.nvim_set_current_win(wid)
        end
    end)
end

-- Utility to create autocmd options that focus a window if its buffer matches a name pattern
local function create_nav_options(name)
    return {
        group = "DapGroup",                          -- Use our custom autocommand group
        pattern = string.format("*%s*", name),       -- Match buffers by wildcard pattern
        callback = navigate                          -- Set the focus logic as the callback
    }
end

return {
    {
        "mfussenegger/nvim-dap", -- Core debugging engine for Neovim
        enabled = true,          -- Plugin is enabled
        lazy = false,            -- Load eagerly (not lazily), so it's available immediately
        config = function()
            local dap = require("dap")

            -- Enable debug logging to help diagnose issues with adapters or configuration
            dap.set_log_level("DEBUG")

            -- F8 to continue execution (start or resume)
            vim.keymap.set("n", "<F8>", dap.continue, { desc = "Debug: Continue" })

            -- F10 to step over a function call
            vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: Step Over" })

            -- F11 to step into a function call
            vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug: Step Into" })

            -- F12 to step out of the current function
            vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Debug: Step Out" })

            -- <leader>b toggles a breakpoint at the current line
            vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })

            -- <leader>B sets a conditional breakpoint (with user input)
            vim.keymap.set("n", "<leader>B", function()
                dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
            end, { desc = "Debug: Set Conditional Breakpoint" })
        end
    },

    {
        "rcarriga/nvim-dap-ui", -- UI for nvim-dap providing panels for scopes, breakpoints, stacks, watches, etc.
        dependencies = {
            "mfussenegger/nvim-dap",       -- Core debugging backend
            "nvim-neotest/nvim-nio",       -- Async utilities required by dap-ui
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            -- Helper to create layout config for a given dap-ui panel (e.g. "repl", "scopes", etc.)
            local function layout(name)
                return {
                    elements = {
                        { id = name },
                    },
                    enter = true,
                    size = 40, -- width of panel
                    position = "right", -- can be "left", "right", "top", or "bottom"
                }
            end

            -- Mapping panel names to layouts and tracking their layout index
            local name_to_layout = {
                repl = { layout = layout("repl"), index = 0 },
                stacks = { layout = layout("stacks"), index = 0 },
                scopes = { layout = layout("scopes"), index = 0 },
                console = { layout = layout("console"), index = 0 },
                watches = { layout = layout("watches"), index = 0 },
                breakpoints = { layout = layout("breakpoints"), index = 0 },
            }

            local layouts = {}
            -- Build final layouts list and assign correct index
            for name, config in pairs(name_to_layout) do
                table.insert(layouts, config.layout)
                name_to_layout[name].index = #layouts
            end

            -- Closes all open panels and toggles the one requested
            local function toggle_debug_ui(name)
                dapui.close()
                local layout_config = name_to_layout[name]

                if layout_config == nil then
                    error(string.format("bad name: %s", name))
                end

                -- Match width to the full window width for fullscreen style panel
                local uis = vim.api.nvim_list_uis()[1]
                if uis ~= nil then
                    layout_config.size = uis.width
                end

                -- Safely toggle only the requested panel by index
                pcall(dapui.toggle, layout_config.index)
            end

            -- Keymaps to toggle each dap-ui panel
            vim.keymap.set("n", "<leader>dr", function() toggle_debug_ui("repl") end, { desc = "Debug: toggle repl ui" })
            vim.keymap.set("n", "<leader>ds", function() toggle_debug_ui("stacks") end, { desc = "Debug: toggle stacks ui" })
            vim.keymap.set("n", "<leader>dw", function() toggle_debug_ui("watches") end, { desc = "Debug: toggle watches ui" })
            vim.keymap.set("n", "<leader>db", function() toggle_debug_ui("breakpoints") end, { desc = "Debug: toggle breakpoints ui" })
            vim.keymap.set("n", "<leader>dS", function() toggle_debug_ui("scopes") end, { desc = "Debug: toggle scopes ui" })
            vim.keymap.set("n", "<leader>dc", function() toggle_debug_ui("console") end, { desc = "Debug: toggle console ui" })

            -- Enable line wrapping in dap-repl for better readability
            vim.api.nvim_create_autocmd("BufEnter", {
                group = "DapGroup",
                pattern = "*dap-repl*",
                callback = function()
                    vim.wo.wrap = true
                end,
            })

            -- Auto-jump to window when buffer is opened for dap-repl and watches
            vim.api.nvim_create_autocmd("BufWinEnter", create_nav_options("dap-repl"))
            vim.api.nvim_create_autocmd("BufWinEnter", create_nav_options("DAP Watches"))

            -- Initialize dap-ui with custom layouts
            dapui.setup({
                layouts = layouts,
                enter = true,
            })

            -- Auto-close UI when debug session ends
            dap.listeners.before.event_terminated.dapui_config = function()
                dapui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                dapui.close()
            end

            -- Route console output to dap-ui console panel
            dap.listeners.after.event_output.dapui_config = function(_, body)
                if body.category == "console" then
                    dapui.eval(body.output)
                end
            end
        end,
    },
    {
        "jay-babu/mason-nvim-dap.nvim", -- Mason integration for managing DAP debuggers
        dependencies = {
            "williamboman/mason.nvim",       -- Mason core package manager
            "mfussenegger/nvim-dap",         -- Core DAP (debug adapter protocol) plugin
            "neovim/nvim-lspconfig",         -- Required for compatibility with mason (though not always directly used here)
        },
        config = function()
            require("mason-nvim-dap").setup({
                -- Optional list of adapters to ensure are always installed
                ensure_installed = {
                    -- Add adapter names here, e.g., "delve", "node2"
                },

                -- Automatically install adapters when needed (lazy-style)
                automatic_installation = true,

                -- Optional handlers for customizing setup per adapter
                handlers = {
                    -- Default handler: fallback setup for all adapters
                    function(config)
                        require("mason-nvim-dap").default_setup(config)
                    end,

                    -- Custom handler for Go's Delve debugger
                    delve = function(config)
                        -- Add a launch config for running current file with args prompt
                        table.insert(config.configurations, 1, {
                            args = function()
                                return vim.split(vim.fn.input("args> "), " ")
                            end,
                            type = "delve",
                            name = "file",
                            request = "launch",
                            program = "${file}",
                            outputMode = "remote", -- Necessary for some terminal behavior
                        })

                        -- Another variant with a more descriptive name
                        table.insert(config.configurations, 1, {
                            args = function()
                                return vim.split(vim.fn.input("args> "), " ")
                            end,
                            type = "delve",
                            name = "file args",
                            request = "launch",
                            program = "${file}",
                            outputMode = "remote",
                        })

                        -- Finally, register with the default setup
                        require("mason-nvim-dap").default_setup(config)
                    end,
                },
            })
        end,
    },}
