local extras = require("myutils.extras")

local M = {}

local CONFIG = { global = true }

-- In global mode, every tab points to this same table.
local GLOBAL_TERMINALS = {}

-- Keyed by tabpage handle, not an array.
local TABS = {}

local Tab = {
	tab_id = -1,
	win_id = -1,
	curr_term_k = -1,
	terminals = {},
}

local function get_tab()
	return TABS[vim.api.nvim_get_current_tabpage()]
end

function Tab:get_terminal_dir()
	return vim.fn.getcwd()
end

function Tab:set_current(term_k)
	term_k = term_k or self.curr_term_k

	if term_k < 1 or term_k > #self.terminals then
		return
	end

	self:start_terminal_window()
	self.curr_term_k = term_k

	local curr = self.terminals[term_k]
	if not vim.api.nvim_buf_is_valid(curr) then
		return
	end
	vim.api.nvim_win_set_buf(self.win_id, curr)
	vim.api.nvim_set_current_buf(curr)
	vim.cmd("startinsert")
end

function Tab:delete_terminal(term_k)
	term_k = term_k or self.curr_term_k

	local terminals = self.terminals
	local curr = terminals[term_k]

	if curr == nil then
		return
	end

	-- Delete the buffer first.
	if vim.api.nvim_buf_is_valid(curr) then
		vim.api.nvim_buf_delete(curr, { force = true })
	end

	-- In global mode this mutates GLOBAL_TERMINALS in place.
	table.remove(terminals, term_k)

	if extras.table_empty(terminals) then
		for _, tab in pairs(TABS) do
			tab.curr_term_k = -1
		end
		return
	end

	-- All tabs share the same terminal list in global mode,
	-- so update every tab's current index.
	if CONFIG.global then
		for _, tab in pairs(TABS) do
			if term_k == tab.curr_term_k then
				-- Prefer the terminal that followed the deleted one.
				-- If the deleted terminal was last, use the new last one.
				tab.curr_term_k = math.min(term_k, #terminals)
			elseif term_k < tab.curr_term_k then
				-- Removing something before the current terminal
				-- shifts the current terminal's index down by one.
				tab.curr_term_k = tab.curr_term_k - 1
			end
		end

		-- Re-select the terminal for the tab that performed the deletion.
		self:set_current()
	else
		-- Local mode: only this tab is affected.
		if term_k == self.curr_term_k then
			self.curr_term_k = math.min(term_k, #terminals)
			self:set_current()
		elseif term_k < self.curr_term_k then
			self.curr_term_k = self.curr_term_k - 1
		end
	end
end

function Tab:delete_all_terminals()
	if CONFIG.global then
		-- All tabs point to GLOBAL_TERMINALS.
		-- Delete the buffers, but preserve the table itself.
		for _, term in ipairs(GLOBAL_TERMINALS) do
			if vim.api.nvim_buf_is_valid(term) then
				vim.api.nvim_buf_delete(term, { force = true })
			end
		end

		-- Clear the shared table in place.
		for i = #GLOBAL_TERMINALS, 1, -1 do
			GLOBAL_TERMINALS[i] = nil
		end

		-- Every tab now has no current terminal.
		for _, tab in pairs(TABS) do
			tab.curr_term_k = -1
			tab.win_id = -1
		end
	else
		-- Local mode.
		for _, term in ipairs(self.terminals) do
			if vim.api.nvim_buf_is_valid(term) then
				vim.api.nvim_buf_delete(term, { force = true })
			end
		end

		self.terminals = {}
		self.curr_term_k = -1
		self.win_id = -1
	end
end

function Tab:start_terminal_window()
	if self.win_id == -1 or not vim.api.nvim_win_is_valid(self.win_id) then
		vim.cmd("botright split")
		vim.cmd("resize 12")
		self.win_id = vim.api.nvim_get_current_win()
	end

	if self.win_id ~= vim.api.nvim_get_current_win() then
		vim.api.nvim_set_current_win(self.win_id)
	end
end

function Tab:spawn_terminal(term_dir)
	self:start_terminal_window()
	term_dir = term_dir or self:get_terminal_dir()
	vim.cmd("lcd " .. vim.fn.fnameescape(term_dir))
	vim.cmd("terminal")
	local term_id = vim.api.nvim_get_current_buf()
	table.insert(self.terminals, term_id)
	self:set_current(#self.terminals)
	vim.cmd("startinsert")

	return term_id
end

function Tab:destroy()
	-- In global mode, terminals survive tab destruction.
	if not CONFIG.global then
		self:delete_all_terminals()
	end

	-- TABS is keyed by tabpage ID, so don't use table.remove().
	TABS[self.tab_id] = nil
end

function Tab:new(tab_id)
	local new_tab = {}
	setmetatable(new_tab, self)
	self.__index = self

	tab_id = tab_id or vim.api.nvim_get_current_tabpage()

	new_tab.tab_id = tab_id
	new_tab.win_id = -1

	if CONFIG.global then
		-- Every tab gets the exact same table.
		new_tab.terminals = GLOBAL_TERMINALS
		if #GLOBAL_TERMINALS > 0 then
			new_tab.curr_term_k = 1
		else
			new_tab.curr_term_k = -1
		end
	else
		new_tab.terminals = {}
		new_tab.curr_term_k = -1
	end
	TABS[tab_id] = new_tab

	return new_tab
end

function M.create_terminal()
	local tab = get_tab()

	if tab ~= nil then
		tab:spawn_terminal()
	end
end

function M.toggle_terminal()
	local current_tab = get_tab()

	if current_tab == nil then
		vim.notify("No terminal started yet (global = " .. tostring(CONFIG.global) .. ")", vim.log.levels.ERROR)
		return
	end

	if #current_tab.terminals == 0 then
		vim.notify("No terminal to toggle", vim.log.levels.INFO)
		return
	end

	if current_tab.win_id ~= -1 and vim.api.nvim_win_is_valid(current_tab.win_id) then
		vim.api.nvim_win_close(current_tab.win_id, true)
		current_tab.win_id = -1
	else
		current_tab:set_current()
	end
end

function M.next_terminal()
	local current_tab = get_tab()

	if current_tab == nil then
		vim.notify("No terminal started yet (global = " .. tostring(CONFIG.global) .. ")", vim.log.levels.ERROR)
		return
	end

	if #current_tab.terminals == 0 then
		vim.notify("No terminal to cycle", vim.log.levels.INFO)
		return
	end

	local next_k = current_tab.curr_term_k % #current_tab.terminals + 1
	current_tab:set_current(next_k)
end

function M.previous_terminal()
	local current_tab = get_tab()

	if current_tab == nil then
		vim.notify("No terminal started yet (global = " .. tostring(CONFIG.global) .. ")", vim.log.levels.ERROR)
		return
	end

	if #current_tab.terminals == 0 then
		vim.notify("No terminal to cycle", vim.log.levels.INFO)
		return
	end

	local previous_k

	if current_tab.curr_term_k == 1 then
		previous_k = #current_tab.terminals
	else
		previous_k = current_tab.curr_term_k - 1
	end

	current_tab:set_current(previous_k)
end

function M.delete_current_terminal()
	local current_tab = get_tab()

	if current_tab == nil then
		vim.notify("No terminal started yet (global = " .. tostring(CONFIG.global) .. ")", vim.log.levels.ERROR)
		return
	end

	if #current_tab.terminals == 0 then
		vim.notify("No terminals to close", vim.log.levels.INFO)
		return
	end

	if current_tab.win_id == -1 then
		vim.notify("Deletion not allowed if toggled off", vim.log.levels.INFO)
		return
	end

	current_tab:delete_terminal()
end

function M.delete_all_terminals()
	local current_tab = get_tab()

	if current_tab == nil then
		vim.notify("No terminal started yet (global = " .. tostring(CONFIG.global) .. ")", vim.log.levels.ERROR)
		return
	end

	if #current_tab.terminals == 0 then
		vim.notify("No terminals to close", vim.log.levels.INFO)
		return
	end

	local ids = vim.deepcopy(current_tab.terminals)
	current_tab:delete_all_terminals()
	vim.notify("Terminals deleted: " .. table.concat(ids, " "), vim.log.levels.INFO)
end

function M.setup(config)
	config = config or {}

	if config.global ~= nil then
		CONFIG.global = config.global
	end

	if get_tab() == nil then
		Tab:new()
	end

	vim.api.nvim_create_autocmd("TabNewEntered", {
		callback = function()
			if get_tab() == nil then
				local tab = Tab:new()
			end
		end,
	})

	vim.api.nvim_create_autocmd("TabClosedPre", {
		callback = function()
			local tab_id = vim.api.nvim_get_current_tabpage()
			local tab = TABS[tab_id]

			if tab then
				tab:destroy()
			end
		end,
	})
end

return M
