-- NOT IN USE AS OF RN

local M = {}

local term_win = nil
local term_buf = nil
local prev_win = nil

local function get_terminal_dir()
	return vim.fn.getcwd()
end

function M.toggle_terminal()
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

return M
