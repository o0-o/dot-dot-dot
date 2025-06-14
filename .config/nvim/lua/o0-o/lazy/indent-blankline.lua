return {
  "lukas-reineke/indent-blankline.nvim", -- Plugin to display indent guides and scope highlights
  enabled = true, -- Enable the plugin (can toggle based on condition)
  main = "ibl",   -- Required entry point for version 3.x+ of indent-blankline
  opts = {
    indent = {
      char = "│", -- Character used to display vertical indent guides
    },
    scope = {
      enabled = true, -- Enable highlighting of the current code block scope
    },
  },
}
