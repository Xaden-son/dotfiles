return {
	{
		"stevearc/conform.nvim",
		config = function()
			local conform = require("conform")
			conform.setup({
				-- No format on save: formatting only runs on <leader>fm.
				-- Without a standalone formatter, conform falls back to the LSP (clangd).
				formatters_by_ft = {},
				default_format_opts = { lsp_format = "fallback" },
			})
			vim.keymap.set({ "n", "v" }, "<leader>fm", function()
				conform.format({ async = true })
			end)
		end,
	},
}
