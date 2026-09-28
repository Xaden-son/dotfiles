vim.g.mapleader = " "

-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>pv", ":Lex<CR>")
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")

vim.keymap.set("n", "<C-Left>", "<C-w><")
vim.keymap.set("n", "<C-Right>", "<C-w>>")
vim.keymap.set("n", "<C-Up>", "<C-w>+")
vim.keymap.set("n", "<C-Down>", "<C-w>-")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set({ "n", "v" }, "<leader>p", [["+p]])
vim.keymap.set("x", "<leader>P", [["_dP]])

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
vim.keymap.set("n", "<leader><leader>", function()
	vim.cmd("so")
end)

vim.keymap.set("n", "<leader>tt", function()
	vim.cmd("split | terminal")
	vim.cmd("resize " .. math.floor(vim.o.lines * 0.3))
	vim.cmd("startinsert")
end)
vim.keymap.set("n", "<leader>tv", ":vsplit | terminal<CR>i")
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

-- VS Code-style editing
-- Delete a word with Alt/Ctrl+Backspace (backward) or Alt/Ctrl+Delete (forward) in insert mode.
vim.keymap.set("i", "<M-BS>", "<C-w>")
vim.keymap.set("i", "<C-BS>", "<C-w>")
vim.keymap.set("i", "<M-Del>", "<C-o>dw")
vim.keymap.set("i", "<C-Del>", "<C-o>dw")

-- Shift+arrows select text; typing or Backspace replaces/deletes the selection.
vim.opt.keymodel = "startsel,stopsel"
vim.opt.selectmode = "key"
vim.opt.selection = "exclusive" -- like VS Code: Shift+Right selects exactly one character

-- Alt+Up/Down moves the current line (or the selection) up/down.
vim.keymap.set("n", "<M-Down>", "<Cmd>m .+1<CR>", { silent = true })
vim.keymap.set("n", "<M-Up>", "<Cmd>m .-2<CR>", { silent = true })
vim.keymap.set("i", "<M-Down>", "<Cmd>m .+1<CR>", { silent = true })
vim.keymap.set("i", "<M-Up>", "<Cmd>m .-2<CR>", { silent = true })
vim.keymap.set("x", "<M-Down>", ":m '>+1<CR>gv", { silent = true })
vim.keymap.set("x", "<M-Up>", ":m '<-2<CR>gv", { silent = true })
vim.keymap.set("s", "<M-Down>", "<C-g>:m '>+1<CR>gv<C-g>", { silent = true })
vim.keymap.set("s", "<M-Up>", "<C-g>:m '<-2<CR>gv<C-g>", { silent = true })
