--  vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

-- vim.opt.colorcolumn = "80,120"

vim.opt.shortmess:append("I")

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.api.nvim_create_autocmd("FileType", {
	pattern = "make",
	callback = function()
		vim.opt_local.expandtab = false
	end,
})

vim.filetype.add({
	extension = {
		h = "c",
	},
})

-- Neovim 0.12 sends LSP progress to the terminal as OSC 9;4 progress bars.
-- Kitty 0.32 doesn't know that sequence and shows each one as a desktop
-- notification ("4;1;0"), so turn the feature off.
pcall(vim.api.nvim_del_augroup_by_name, "nvim.progress")
