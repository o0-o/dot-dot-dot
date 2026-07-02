return {
	"neovim/nvim-lspconfig",

	-- Dependencies for LSP, formatting, autocompletion, snippets, etc.
	dependencies = {
		"stevearc/conform.nvim",          -- Formatter integration
		"williamboman/mason.nvim",        -- LSP/DAP/package manager
		"williamboman/mason-lspconfig.nvim", -- Bridge between mason and lspconfig
		"hrsh7th/cmp-nvim-lsp",           -- LSP source for nvim-cmp
		"hrsh7th/cmp-buffer",             -- Buffer completion source
		"hrsh7th/cmp-path",               -- Path completion source
		"hrsh7th/cmp-cmdline",            -- Cmdline completion
		"hrsh7th/nvim-cmp",               -- Completion engine
		"L3MON4D3/LuaSnip",               -- Snippet engine
		"saadparwaiz1/cmp_luasnip",       -- Luasnip source for nvim-cmp
		"j-hui/fidget.nvim",              -- LSP status UI
	},

	config = function()
		-- Configure conform.nvim (formatting) with filetype mappings (currently empty)
		require("conform").setup({
			formatters_by_ft = {}
		})

		-- Setup LSP client capabilities (extended for autocompletion)
		local cmp_lsp = require("cmp_nvim_lsp")
		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			cmp_lsp.default_capabilities()
		)

		-- Enable LSP status updates in UI
		require("fidget").setup({})

		-- Setup mason (LSP installer)
		require("mason").setup()

		-- Setup mason-lspconfig with automatic installation
		require("mason-lspconfig").setup({
			-- Specify servers to auto-install
			ensure_installed = {
				"lua_ls", -- Lua language server
			},
			-- Generic handler for all installed servers
			handlers = {
				function(server_name)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities
					})
				end,
			}
		})

		-- === COMPLETION SETUP (commented out) ===
		-- Configuration for nvim-cmp (completion engine), includes:
		-- * luasnip integration
		-- * Copilot (if present)
		-- * Key mappings for completion navigation
		--[[
		local cmp = require('cmp')
		local cmp_select = { behavior = cmp.SelectBehavior.Select }

		cmp.setup({
			snippet = {
				expand = function(args)
					require('luasnip').lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
				['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
				['<C-y>'] = cmp.mapping.confirm({ select = true }),
				["<C-Space>"] = cmp.mapping.complete(),
			}),
			sources = cmp.config.sources({
				{ name = "copilot", group_index = 2 },
				{ name = 'nvim_lsp' },
				{ name = 'luasnip' },
			}, {
				{ name = 'buffer' },
			})
		})
		--]]

		-- Customize LSP diagnostics display
		vim.diagnostic.config({
			update_in_insert = true,  -- Show diagnostics while typing
			virtual_text = true,      -- Inline virtual text for diagnostics
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = "always", -- Always show source in float
				header = "",
				prefix = "",
			},
		})
	end
}
