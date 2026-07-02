return {
    {
        "nvim-treesitter/nvim-treesitter", -- Main Treesitter plugin for syntax highlighting and parsing

        build = ":TSUpdate", -- Run :TSUpdate after install to ensure parsers are up to date

        config = function()
            require("nvim-treesitter.configs").setup({
                -- ensure_installed = { ... }: optionally specify parsers to ensure are installed
                -- Leave commented to install on demand

                sync_install = false, -- Don't block UI while installing parsers
                auto_install = true,  -- Automatically install missing parsers on buffer enter

                indent = {
                    enable = true, -- Enable Treesitter-based indentation
                },

                highlight = {
                    enable = true, -- Enable syntax highlighting via Treesitter

                    -- Disable for large files, HTML (manually), or Ansible YAML
                    disable = function(lang, buf)
                        if lang == "html" then
                            print("disabled")
                            return true
                        end

                        local max_filesize = 100 * 1024 -- 100 KB
                        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                        if ok and stats and stats.size > max_filesize then
                            vim.notify(
                                "File larger than 100KB — Treesitter disabled for performance",
                                vim.log.levels.WARN,
                                { title = "Treesitter" }
                            )
                            return true
                        end

                        local ft = vim.api.nvim_buf_get_option(buf, "filetype")
                        if ft == "yaml.ansible" then
                            return true
                        end
                    end,

                    additional_vim_regex_highlighting = { "markdown" }, -- Use both regex and Treesitter for markdown
                },
            })

            -- Register custom Treesitter parser for `templ` (templating language for Go)
            local treesitter_parser_config = require("nvim-treesitter.parsers").get_parser_configs()
            treesitter_parser_config.templ = {
                install_info = {
                    url = "https://github.com/vrischmann/tree-sitter-templ.git",
                    files = { "src/parser.c", "src/scanner.c" },
                    branch = "master",
                },
            }

            -- Associate .templ files with the `templ` parser
            vim.treesitter.language.register("templ", "templ")
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter-context", -- Shows current code context at top of window
        after = "nvim-treesitter",

        config = function()
            require("treesitter-context").setup({
                enable = true,             -- Enable plugin
                multiwindow = false,       -- Don't show context across split windows
                max_lines = 0,             -- Unlimited context lines
                min_window_height = 0,     -- Always show context regardless of window height
                line_numbers = true,       -- Show line numbers in context
                multiline_threshold = 20,  -- Collapse context if block > 20 lines
                trim_scope = "outer",      -- Prefer to keep outer context when trimming
                mode = "cursor",           -- Use cursor position for determining context
                separator = nil,           -- No separator line
                zindex = 20,               -- Display above normal text
                on_attach = nil,           -- No special attach behavior

                -- Match nodes by type to display in the context window
                patterns = {
                    default = {
                        "class_definition",
                        "function_definition",
                        "method_definition",
                        "if_statement",
                        "for_statement",
                        "while_statement",
                        "case_clause",
                    },
                },
            })
        end,
    },
}
