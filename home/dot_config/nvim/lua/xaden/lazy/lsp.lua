return {
	{
		"neovim/nvim-lspconfig",
		dependencies = { "saghen/blink.cmp" },
		config = function()
			vim.lsp.config("yamlls", {
				settings = {
					yaml = {
						schemas = {
							["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "compose*.y*ml",
						},
					},
				},
			})

			-- Standalone .java files (no pom.xml/gradle/.git) get only syntax errors,
			-- so fall back to the file's folder as the project root.
			vim.lsp.config("jdtls", {
				root_dir = function(bufnr, on_dir)
					local root = vim.fs.root(bufnr, {
						{ "mvnw", "gradlew", "settings.gradle", "settings.gradle.kts", ".git" },
						{ "build.xml", "pom.xml", "build.gradle", "build.gradle.kts" },
					})
					on_dir(root or vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr)))
				end,
			})

			local servers = {
				"clangd",
				"jdtls",
				-- "gopls",
				-- "lua_ls",
				-- "ts_ls",
				-- "pyright",
				-- "postgres_lsp",
				-- "dockerls",
				-- "yamlls",
			}
			for _, server in ipairs(servers) do
				vim.lsp.enable(server)
			end

			vim.diagnostic.config({
				virtual_text = true,
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
				float = { border = "rounded" },
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(event)
					local opts = { buffer = event.buf }
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
					vim.keymap.set("n", "[d", function()
						vim.diagnostic.jump({ count = -1, float = true })
					end, opts)
					vim.keymap.set("n", "]d", function()
						vim.diagnostic.jump({ count = 1, float = true })
					end, opts)
				end,
			})
		end,
	},
}
