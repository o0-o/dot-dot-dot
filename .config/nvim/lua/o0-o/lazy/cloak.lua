return {
	-- Automatically hides sensitive values in files like `.env` using a masking character
	"laytan/cloak.nvim",
	enabled = true,
	config = function()
		require("cloak").setup({
			-- Master toggle (you can disable it globally if needed)
			enabled = true,

			-- Character used to mask/cloak the secret values
			cloak_character = "*",

			-- Highlight group to style the cloaked text (e.g., gray like comments)
			highlight_group = "Comment",

			-- Define which files and patterns should have secrets cloaked
			patterns = {
				{
					-- Target files that start with ".env" (e.g., .env, .env.local, .env.production)
					file_pattern = {
						".env*",
					},

					-- Regex pattern that matches everything after the `=`
					-- Example: DB_PASSWORD=mysecret → cloaks `=mysecret`
					cloak_pattern = "=.+"
				},
			},
		})
	end
}
