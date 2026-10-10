local extras = require("myutils.extras")

vim.g.mapleader = " "

extras.map("n", "j", "gj", { desc = "Move down by visual line" })
extras.map("n", "k", "gk", { desc = "Move up by visual line" })
extras.map("n", "<leader>a", "ggVG", { desc = "Select all" })
extras.map("n", "<leader>e", vim.cmd.Ex, { desc = "Open file explorer" })
extras.map("n", "<leader>w", function()
	local filename = vim.fn.expand("%")

	if filename == "" then
		local new_filename = vim.fn.input("Save as: ")

		if new_filename ~= "" then
			vim.cmd("saveas " .. vim.fn.fnameescape(new_filename))
			vim.cmd("filetype detect")
		end
	else
		vim.cmd("write")
	end
end, { desc = "Save buffer" })
extras.map("n", "<leader>q", "<cmd>qa<cr>", { desc = "Quit all" })
extras.map("n", "<leader>bn", "<cmd>tabnew | set filetype=markdown<CR>", { desc = "New markdown buffer" })
extras.map("n", "<leader>bp", function()
	local dir = vim.fn.expand("~/Documents/projects/temp_scripts")
	local path = dir .. "/temp.py"

	vim.fn.mkdir(dir, "p")
	vim.fn.writefile({}, path)
	vim.cmd("tabnew " .. vim.fn.fnameescape(path))
	vim.cmd("tcd " .. vim.fn.fnameescape(dir))
end, { desc = "Open python scratch-buffer" })
extras.map("n", "<leader>bd", function()
	local buf = vim.api.nvim_get_current_buf()

	-- Close DAP View buffers in the current tab
	for _, b in ipairs(vim.fn.tabpagebuflist()) do
		if vim.api.nvim_buf_is_valid(b) then
			local filetype = vim.bo[b].filetype

			if filetype:find("dap%-view", 1) then
				vim.api.nvim_buf_delete(b, { force = true })
			end
		end
	end

	local is_empty = vim.api.nvim_buf_line_count(buf) == 1 and vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] == ""

	if is_empty or not vim.bo[buf].modified then
		vim.cmd("bdelete")
	else
		vim.cmd("tabclose")
	end
end, { desc = "Close current buffer" })
extras.map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
extras.map("n", "<leader>c", "gcc", { remap = true, desc = "Comment current line" })
extras.map("v", "<leader>c", "gc", { remap = true, desc = "Comment selected lines" })

extras.map("n", "J", "<C-i>", { desc = "Jump forward" })
extras.map("n", "K", "<C-o>", { desc = "Jump back" })

-- ===============================================
-- https://medium.com/unixification/must-have-neovim-keymaps-51c283394070

extras.map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
extras.map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
extras.map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
extras.map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

extras.map("t", "<C-h>", "<cmd>wincmd h<CR>", { desc = "Move to left window" })
extras.map("t", "<C-j>", "<cmd>wincmd j<CR>", { desc = "Move to lower window" })
extras.map("t", "<C-k>", "<cmd>wincmd k<CR>", { desc = "Move to upper window" })
extras.map("t", "<C-l>", "<cmd>wincmd l<CR>", { desc = "Move to right window" })

extras.map("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
extras.map("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
extras.map("n", "<C-Left>", ":vertical resize +2<CR>", { desc = "Increase window width" })
extras.map("n", "<C-Right>", ":vertical resize -2<CR>", { desc = "Decrease window width" })

extras.map("t", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
extras.map("t", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
extras.map("t", "<C-Left>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })
extras.map("t", "<C-Right>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })

-- these may be a problem if I ever install https://github.com/mbbill/undotree
extras.map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })
extras.map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })

extras.map("v", "<", "<gv", { desc = "Indent selected lines left" })
extras.map("v", ">", ">gv", { desc = "Indent selected lines right" })

extras.map("n", "<TAB>", "gt", { desc = "Next tab" })
extras.map("n", "<S-TAB>", "gT", { desc = "Previous tab" })

-- ===============================================
extras.map({ "n", "v" }, "<Esc>", function()
	if vim.v.hlsearch == 1 then
		vim.cmd("nohlsearch")
	end
	return "<Esc>"
end, { expr = true, desc = "Clear search highlight" })

-- ================================================
extras.map("n", "<leader>s", function()
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
end, { desc = "Suggest spelling corrections" })
