local extras = require("myutils.extras")
local terminal = require("myutils.terminal")

vim.g.mapleader = " "

extras.map("n", "j", "gj")
extras.map("n", "k", "gk")
extras.map("n", "<leader>a", "ggVG")
extras.map("n", "<leader>pv", vim.cmd.Ex)
extras.map("n", "<leader>s", function()
	local filename = vim.fn.expand("%")
	if filename == "" then
		vim.cmd("saveas " .. vim.fn.input("Save as: "))
	else
		vim.cmd("write")
	end
end)
extras.map("n", "<leader>n", "<cmd>tabnew | set filetype=markdown<CR>", { desc = "New markdown buffer" })
extras.map("t", "<Esc><Esc>", "<C-\\><C-n>")
extras.map("n", "<leader>c", "gcc", { remap = true })
extras.map("v", "<leader>c", "gc", { remap = true })

-- ===============================================
-- https://medium.com/unixification/must-have-neovim-keymaps-51c283394070

extras.map("n", "<C-h>", "<C-w>h")
extras.map("n", "<C-j>", "<C-w>j")
extras.map("n", "<C-k>", "<C-w>k")
extras.map("n", "<C-l>", "<C-w>l")

extras.map("t", "<C-h>", "<cmd>wincmd h<CR>")
extras.map("t", "<C-j>", "<cmd>wincmd j<CR>")
extras.map("t", "<C-k>", "<cmd>wincmd k<CR>")
extras.map("t", "<C-l>", "<cmd>wincmd l<CR>")

extras.map("n", "<C-Down>", ":resize -2<CR>")
extras.map("n", "<C-Up>", ":resize +2<CR>")
extras.map("n", "<C-Left>", ":vertical resize +2<CR>")
extras.map("n", "<C-Right>", ":vertical resize -2<CR>")

extras.map("t", "<C-Down>", "<cmd>resize -2<CR>")
extras.map("t", "<C-Up>", "<cmd>resize +2<CR>")
extras.map("t", "<C-Left>", "<cmd>vertical resize -2<CR>")
extras.map("t", "<C-Right>", "<cmd>vertical resize +2<CR>")

-- these may be a problem if I ever install https://github.com/mbbill/undotree
extras.map("v", "J", ":m '>+1<CR>gv=gv")
extras.map("v", "K", ":m '<-2<CR>gv=gv")

extras.map("v", "<", "<gv")
extras.map("v", ">", ">gv")

extras.map("n", "<TAB>", "gt")
extras.map("n", "<S-TAB>", "gT")
extras.map("n", "<leader>cc", function()
	local buf = vim.api.nvim_get_current_buf()

	local is_empty = vim.api.nvim_buf_line_count(buf) == 1 and vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] == ""

	if is_empty or not vim.bo[buf].modified then
		vim.cmd("bdelete")
	else
		vim.cmd("tabclose")
	end
end)

-- ===============================================

extras.map("n", "<leader>tc", terminal.create_terminal)
extras.map("n", "<leader>tt", terminal.toggle_terminal)
extras.map("n", "<leader>tn", terminal.next_terminal)
-- extras.map("t", "<Tab>", terminal.next_terminal)
extras.map("n", "<leader>tp", terminal.previous_terminal)
extras.map("n", "<leader>td", terminal.delete_current_terminal)

extras.map({ "n", "v" }, "<Esc>", function()
	if vim.v.hlsearch == 1 then
		vim.cmd("nohlsearch")
	end
	return "<Esc>"
end, { expr = true })

-- ================================================

extras.map("n", "ee", function()
	local word = vim.fn.expand("<cword>")
	if word == "" then
		return
	end
	local suggestions = vim.fn.spellsuggest(word, 10)
	extras.select_in_float(suggestions, function(choice)
		if not choice then
			return
		end
		vim.cmd("normal! ciw" .. choice)
	end)
end)
