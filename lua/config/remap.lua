vim.g.mapleader = " "

function Map(mode, lhs, rhs, opts)
	local options = { remap = false, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.keymap.set(mode, lhs, rhs, options)
end

Map("n", "j", "gj")
Map("n", "k", "gk")
Map("n", "<leader>a", "ggVG")
Map("n", "<leader>pv", vim.cmd.Ex)
Map("n", "<leader>s", function()
	local filename = vim.fn.expand("%")
	if filename == "" then
		vim.cmd("saveas " .. vim.fn.input("Save as: "))
	else
		vim.cmd("write")
	end
end)
Map("n", "<leader>n", "<cmd>tabnew | set filetype=markdown<CR>", { desc = "New markdown buffer" })
Map("t", "<Esc><Esc>", "<C-\\><C-n>")
Map("n", "<leader>c", "gcc", { remap = true })
Map("v", "<leader>c", "gc", { remap = true })

-- ===============================================
-- https://medium.com/unixification/must-have-neovim-keymaps-51c283394070

Map("n", "<C-h>", "<C-w>h")
Map("n", "<C-j>", "<C-w>j")
Map("n", "<C-k>", "<C-w>k")
Map("n", "<C-l>", "<C-w>l")

Map("t", "<C-h>", "<cmd>wincmd h<CR>")
Map("t", "<C-j>", "<cmd>wincmd j<CR>")
Map("t", "<C-k>", "<cmd>wincmd k<CR>")
Map("t", "<C-l>", "<cmd>wincmd l<CR>")

Map("n", "<C-Down>", ":resize -2<CR>")
Map("n", "<C-Up>", ":resize +2<CR>")
Map("n", "<C-Left>", ":vertical resize -2<CR>")
Map("n", "<C-Right>", ":vertical resize +2<CR>")

Map("t", "<C-Down>", "<cmd>resize -2<CR>")
Map("t", "<C-Up>", "<cmd>resize +2<CR>")
Map("t", "<C-Left>", "<cmd>vertical resize -2<CR>")
Map("t", "<C-Right>", "<cmd>vertical resize +2<CR>")

-- these may be a problem if I ever install https://github.com/mbbill/undotree
Map("v", "J", ":m '>+1<CR>gv=gv")
Map("v", "K", ":m '<-2<CR>gv=gv")

Map("v", "<", "<gv")
Map("v", ">", ">gv")

Map("n", "<TAB>", "gt")
Map("n", "<S-TAB>", "gT")
Map("n", "<leader>cc", function()
	local buf = vim.api.nvim_get_current_buf()

	local is_empty = vim.api.nvim_buf_line_count(buf) == 1 and vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] == ""

	if is_empty or not vim.bo[buf].modified then
		vim.cmd("bdelete")
	else
		vim.cmd("tabclose")
	end
end)
-- ===============================================

Map("n", "gl", vim.diagnostic.open_float)

Map("i", "`", function()
	if vim.fn.pumvisible() == 1 then
		vim.g.completion_cancelled = true
		return "<C-e>"
	end
	return "`"
end, {
	expr = true,
	desc = "Close completion popup or leave insert mode",
})

Map("i", "<CR>", function()
	if vim.fn.pumvisible() == 1 then
		return "<C-y>"
	end
	return "<CR>"
end, { expr = true, desc = "Choose the currently focused autocomplete ouption" })

Map("i", "<Tab>", function()
	if vim.fn.pumvisible() == 1 then
		return "<C-n>"
	end
	return "<Tab>"
end, { expr = true, desc = "Cycle autocomplete options" })

-- ==================================================

local term_win = nil
local term_buf = nil
local prev_win = nil

local function get_terminal_dir()
	-- local buf = vim.api.nvim_get_current_buf()
	-- local ft = vim.bo[buf].filetype
	-- local path = ''
	--
	-- -- Netrw: use the directory being browsed
	-- if ft == "netrw" then
	--     path = vim.fn.expand("%:p")
	-- end
	--
	-- -- Regular file: use parent directory
	-- local file = vim.api.nvim_buf_get_name(buf)
	-- if file ~= "" then
	--     path = vim.fn.fnamemodify(file, ":p:h")
	-- end
	--
	-- if path ~= "" then
	--     return path
	-- end

	-- Fallback to current working directory
	return vim.fn.getcwd()
end

local function toggle_terminal()
	-- Close terminal if it exists
	if term_win and vim.api.nvim_win_is_valid(term_win) then
		vim.api.nvim_win_close(term_win, true)

		if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
			vim.api.nvim_buf_delete(term_buf, { force = true })
		end

		term_win = nil
		term_buf = nil

		if prev_win and vim.api.nvim_win_is_valid(prev_win) then
			vim.api.nvim_set_current_win(prev_win)
		end

		return
	end

	-- Save current window
	prev_win = vim.api.nvim_get_current_win()

	local term_dir = get_terminal_dir()

	-- Create terminal split
	vim.cmd("botright split")
	vim.cmd("resize 12")

	-- Set the terminal window's local cwd
	vim.cmd("lcd " .. vim.fn.fnameescape(term_dir))

	vim.cmd("terminal")

	-- Store terminal references
	term_win = vim.api.nvim_get_current_win()
	term_buf = vim.api.nvim_get_current_buf()

	-- Enter terminal mode
	vim.cmd("startinsert")
end

-- Normal mode
Map("n", "<C-`>", toggle_terminal, {
	desc = "Toggle terminal",
})

-- Terminal mode
Map("t", "<C-`>", function()
	vim.cmd("stopinsert") -- leave terminal mode
	toggle_terminal()
end, {
	desc = "Toggle terminal",
})

-- ================================================

Map("i", "<C-s>", function()
	local word = vim.fn.expand("<cword>")

	if word == "" then
		return
	end

	local suggestions = vim.fn.spellsuggest(word, 10)

	local items = {}
	for _, suggestion in ipairs(suggestions) do
		table.insert(items, {
			word = suggestion,
			menu = "[spell]",
		})
	end

	if #items > 0 then
		vim.fn.complete(vim.fn.col(".") - #word, items)
	end
end, {
	desc = "Spell suggestions",
})
