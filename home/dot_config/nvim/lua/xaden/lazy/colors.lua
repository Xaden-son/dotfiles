return {
	{
		"EdenEast/nightfox.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("nightfox").setup({
				options = {
					transparent = true,
				},
			})
			vim.cmd.colorscheme("nordfox")
			-- Let the terminal background show through the tree and inactive windows too.
			for _, group in ipairs({ "NvimTreeNormal", "NvimTreeNormalNC", "NvimTreeEndOfBuffer", "NormalNC", "EndOfBuffer", "SignColumn" }) do
				vim.api.nvim_set_hl(0, group, { bg = "none" })
			end
		end,
	},
}
