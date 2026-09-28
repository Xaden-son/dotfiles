-- 3-pane layout: [ nvim-tree | file window | terminal ]
-- <leader>w builds it; plain `nvim`/`nvim file` never auto-opens it;
-- `nvim <dir>` auto-builds it with an empty normal buffer in the middle.

local M = {}

local function get_windows_info()
	local info = { tree = nil, term = nil, others = {} }
	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		local buf = vim.api.nvim_win_get_buf(win)
		local ft = vim.bo[buf].filetype
		local bt = vim.bo[buf].buftype
		if ft == "NvimTree" then
			info.tree = win
		elseif bt == "terminal" then
			info.term = win
		else
			table.insert(info.others, win)
		end
	end
	return info
end

-- Builds the layout, reopening whichever pane is missing. Idempotent: an
-- existing tree, file window or terminal is reused, never duplicated.
function M.open()
	local info = get_windows_info()

	if not info.tree then
		vim.cmd("NvimTreeOpen")
		info = get_windows_info()
	end

	local file_win = info.others[1]
	if not file_win then
		-- The file pane was closed: recreate it between the tree and the terminal.
		if info.term then
			vim.api.nvim_set_current_win(info.term)
			vim.cmd("leftabove vnew")
		else
			vim.api.nvim_set_current_win(info.tree)
			vim.cmd("rightbelow vnew")
		end
		file_win = vim.api.nvim_get_current_win()
	end

	if not info.term then
		vim.api.nvim_set_current_win(file_win)
		vim.cmd("botright vsplit")
		vim.cmd("terminal")
	end

	vim.api.nvim_set_current_win(file_win)
	vim.cmd("stopinsert")
	vim.cmd("wincmd =")
end

vim.keymap.set("n", "<leader>w", M.open, { desc = "Open 3-pane layout (tree | file | terminal)" })

-- Directional window navigation from insert and terminal modes.
-- Normal-mode <C-h/j/k/l> already live in remap.lua.
for key, dir in pairs({ h = "h", j = "j", k = "k", l = "l" }) do
	local lhs = "<C-" .. key .. ">"
	local rhs = "<C-\\><C-n><C-w>" .. dir
	vim.keymap.set("i", lhs, rhs, { silent = true })
	vim.keymap.set("t", lhs, rhs, { silent = true })
end

-- Cycle windows: tree -> file -> terminal -> tree.
vim.keymap.set("n", "<M-w>", "<C-w>w", { silent = true })
vim.keymap.set("i", "<M-w>", "<C-\\><C-n><C-w>w", { silent = true })
vim.keymap.set("t", "<M-w>", "<C-\\><C-n><C-w>w", { silent = true })

-- Save with Ctrl+s from normal, insert and visual mode.
vim.keymap.set({ "n", "i" }, "<C-s>", "<Cmd>write<CR>", { silent = true, desc = "Save file" })
vim.keymap.set("v", "<C-s>", "<Esc><Cmd>write<CR>", { silent = true, desc = "Save file" })

local function is_aux(win)
	local buf = vim.api.nvim_win_get_buf(win)
	return vim.bo[buf].filetype == "NvimTree" or vim.bo[buf].buftype == "terminal"
end

-- :q / :wq in the last file window quits Neovim entirely, like plain vim,
-- instead of leaving only the tree and the terminal behind.
vim.api.nvim_create_autocmd("QuitPre", {
	callback = function()
		local cur = vim.api.nvim_get_current_win()
		if is_aux(cur) or vim.bo.modified then
			return
		end
		for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
			if win ~= cur and vim.api.nvim_win_get_config(win).relative == "" and not is_aux(win) then
				return -- another file window stays open, so only this one closes
			end
		end
		pcall(vim.cmd, "NvimTreeClose")
		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			if vim.bo[buf].buftype == "terminal" then
				pcall(vim.api.nvim_buf_delete, buf, { force = true })
			end
		end
	end,
})

-- Jump straight into insert mode whenever a terminal window gets focus.
vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
	pattern = "term://*",
	callback = function()
		vim.cmd("startinsert")
	end,
})

-- Auto-build the layout only when nvim was started with a single directory
-- argument (`nvim .` / `nvim some/dir`). Plain `nvim` or `nvim file.c` must
-- not trigger this. nvim-tree's own directory hijacking is disabled
-- (hijack_directories.enable = false in nvim-tree.lua) so this is the only
-- code path that reacts to a directory argument.
vim.api.nvim_create_autocmd("VimEnter", {
	once = true,
	nested = true,
	callback = function()
		if vim.fn.argc() ~= 1 then
			return
		end
		local arg = vim.fn.argv(0)
		local path = vim.fn.fnamemodify(arg, ":p")
		if vim.fn.isdirectory(path) ~= 1 then
			return
		end
		vim.cmd("cd " .. vim.fn.fnameescape(path))
		vim.cmd("enew") -- empty normal buffer, not the directory buffer
		M.open()
	end,
})

return M
