local extras = require("myutils.extras")
local terminal = require("myutils.terminal")

vim.g.mapleader = " "

extras.Map("n", "j", "gj")
extras.Map("n", "k", "gk")
extras.Map("n", "<leader>a", "ggVG")
extras.Map("n", "<leader>pv", vim.cmd.Ex)
extras.Map("n", "<leader>s", function()
	local filename = vim.fn.expand("%")
	if filename == "" then
		vim.cmd("saveas " .. vim.fn.input("Save as: "))
	else
		vim.cmd("write")
	end
end)
extras.Map("n", "<leader>n", "<cmd>tabnew | set filetype=markdown<CR>", { desc = "New markdown buffer" })
extras.Map("t", "<Esc><Esc>", "<C-\\><C-n>")
extras.Map("n", "<leader>c", "gcc", { remap = true })
extras.Map("v", "<leader>c", "gc", { remap = true })

-- ===============================================
-- https://medium.com/unixification/must-have-neovim-keymaps-51c283394070

extras.Map("n", "<C-h>", "<C-w>h")
extras.Map("n", "<C-j>", "<C-w>j")
extras.Map("n", "<C-k>", "<C-w>k")
extras.Map("n", "<C-l>", "<C-w>l")

extras.Map("t", "<C-h>", "<cmd>wincmd h<CR>")
extras.Map("t", "<C-j>", "<cmd>wincmd j<CR>")
extras.Map("t", "<C-k>", "<cmd>wincmd k<CR>")
extras.Map("t", "<C-l>", "<cmd>wincmd l<CR>")

extras.Map("n", "<C-Down>", ":resize -2<CR>")
extras.Map("n", "<C-Up>", ":resize +2<CR>")
extras.Map("n", "<C-Left>", ":vertical resize +2<CR>")
extras.Map("n", "<C-Right>", ":vertical resize -2<CR>")

extras.Map("t", "<C-Down>", "<cmd>resize -2<CR>")
extras.Map("t", "<C-Up>", "<cmd>resize +2<CR>")
extras.Map("t", "<C-Left>", "<cmd>vertical resize -2<CR>")
extras.Map("t", "<C-Right>", "<cmd>vertical resize +2<CR>")

-- these may be a problem if I ever install https://github.com/mbbill/undotree
extras.Map("v", "J", ":m '>+1<CR>gv=gv")
extras.Map("v", "K", ":m '<-2<CR>gv=gv")

extras.Map("v", "<", "<gv")
extras.Map("v", ">", ">gv")

extras.Map("n", "<TAB>", "gt")
extras.Map("n", "<S-TAB>", "gT")
extras.Map("n", "<leader>cc", function()
	local buf = vim.api.nvim_get_current_buf()

	local is_empty = vim.api.nvim_buf_line_count(buf) == 1 and vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] == ""

	if is_empty or not vim.bo[buf].modified then
		vim.cmd("bdelete")
	else
		vim.cmd("tabclose")
	end
end)
-- ===============================================

extras.Map("n", "gl", vim.diagnostic.open_float)

extras.Map("i", "`", function()
	if vim.fn.pumvisible() == 1 then
		vim.g.completion_cancelled = true
		return "<C-e>"
	end
	return "`"
end, {
	expr = true,
	desc = "Close completion popup or leave insert mode",
})

extras.Map("i", "<CR>", function()
	if vim.fn.pumvisible() == 1 then
		return "<C-y>"
	end
	return "<CR>"
end, { expr = true, desc = "Choose the currently focused autocomplete ouption" })

extras.Map("i", "<Tab>", function()
	if vim.fn.pumvisible() == 1 then
		return "<C-n>"
	end
	return "<Tab>"
end, { expr = true, desc = "Cycle autocomplete options" })

-- ==================================================

extras.Map("n", "<leader>tc", terminal.create_terminal)
extras.Map("n", "<leader>tt", terminal.toggle_terminal)
extras.Map("n", "<leader>tn", terminal.next_terminal)
extras.Map("t", "<Tab>", terminal.next_terminal)
extras.Map("n", "<leader>tp", terminal.previous_terminal)
extras.Map("n", "<leader>td", terminal.delete_current_terminal)

extras.Map({ "n", "v" }, "<Esc>", function()
	if vim.v.hlsearch == 1 then
		vim.cmd("nohlsearch")
	end
	return "<Esc>"
end, { expr = true })

-- ================================================

-- extras.Map("i", "<C-s>", function()
-- 	local word = vim.fn.expand("<cword>")
--
-- 	if word == "" then
-- 		return
-- 	end
--
-- 	local suggestions = vim.fn.spellsuggest(word, 10)
--
-- 	local items = {}
-- 	for _, suggestion in ipairs(suggestions) do
-- 		table.insert(items, {
-- 			word = suggestion,
-- 			menu = "[spell]",
-- 		})
-- 	end
--
-- 	if #items > 0 then
-- 		vim.fn.complete(vim.fn.col(".") - #word, items)
-- 	end
-- end, {
-- 	desc = "Spell suggestions",
-- })
