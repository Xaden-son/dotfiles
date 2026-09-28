return {
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1

			local function on_attach(bufnr)
				local api = require("nvim-tree.api")
				api.config.mappings.default_on_attach(bufnr)

				local opts = function(desc)
					return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
				end

				-- Override the default C-h/j/k/l (and any other) tree-local
				-- mappings so Ctrl+direction always navigates windows, even
				-- from inside the tree.
				vim.keymap.set("n", "<C-h>", "<C-w>h", opts("Go to left window"))
				vim.keymap.set("n", "<C-j>", "<C-w>j", opts("Go to below window"))
				vim.keymap.set("n", "<C-k>", "<C-w>k", opts("Go to above window"))
				vim.keymap.set("n", "<C-l>", "<C-w>l", opts("Go to right window"))
				vim.keymap.set("n", "<M-w>", "<C-w>w", opts("Cycle windows"))
			end

			require("nvim-tree").setup({
				on_attach = on_attach,
				hijack_directories = { enable = false },
				view = {
					width = 36,
					side = "left",
					preserve_window_proportions = true,
					number = false,
					relativenumber = false,
					signcolumn = "yes",
				},
				renderer = {
					icons = {
						glyphs = {
							git = {
								unstaged = "M",
								staged = "S",
								unmerged = "",
								renamed = "R",
								untracked = "?",
								deleted = "D",
								ignored = "◌",
							},
						},
					},
				},
				git = { enable = true },
				filters = { git_ignored = false },
				diagnostics = { enable = true, show_on_dirs = true },
				actions = { open_file = { quit_on_open = false } },
			})

			vim.keymap.set("n", "<leader>pv", ":NvimTreeToggle<CR>")
		end,
	},
}
