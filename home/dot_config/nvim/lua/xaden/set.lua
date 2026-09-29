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

-- Neovim 0.12 asks Kitty for key release events (keyboard protocol flags 3).
-- Kitty 0.32 sends the release of Enter/Tab/Backspace as the plain key byte,
-- so each of those keys fires twice. Drop back to flags 1 (disambiguate only);
-- Neovim pops the flags on exit, so the shell is left untouched.
if vim.env.KITTY_WINDOW_ID then
	vim.api.nvim_create_autocmd({ "UIEnter", "VimResume" }, {
		callback = function()
			vim.defer_fn(function()
				vim.api.nvim_ui_send("\27[=1;1u")
			end, 100)
		end,
	})
end
