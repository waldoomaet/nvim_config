local M = {}

function M.table_empty(tab)
    return next(tab) == nil
end
function M.print_table(tab)
	print("{")
    for k, v in pairs(tab) do
        print("    " .. k .. " -> " .. (type(v) ~= "table" and v or "table"))
    end
    print("}")
end

function M.Map(mode, lhs, rhs, opts)
	local options = { remap = false, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.keymap.set(mode, lhs, rhs, options)
end

-- https://stackoverflow.com/a/40180465
function M.split(s, sep)
	local fields = {}
	local sep = sep or " "
	local pattern = string.format("([^%s]+)", sep)
	string.gsub(s, pattern, function(c)
		fields[#fields + 1] = c
	end)
	return fields
end

local function fast_event_notify(message, level)
	vim.schedule(function()
		vim.notify(message, level)
	end)
end

local function on_exit(obj)
	local code = obj.code
	local stdout = obj.stdout
	local stderr = obj.stderr

	if code == 0 then
		local last_line = M.split(stdout, "\n")
		last_line = last_line[#last_line]
		fast_event_notify("Process exited with 0 (" .. last_line .. ")", vim.log.levels.INFO)
		-- if stdout == "" then
		-- 	fast_event_notify("Process exited with 0", vim.log.levels.INFO)
		-- else
		-- 	fast_event_notify(stdout, vim.log.levels.INFO)
		-- end
	else
		local last_line = M.split(stdout, "\n")
		last_line = last_line[#last_line]
		fast_event_notify(
			string.format("Process exited with code %d (" .. last_line .. ")", code),
			vim.log.levels.ERROR
		)
		-- if stderr == "" then
		-- 	fast_event_notify(string.format("Process exited with code %d", code), vim.log.levels.ERROR)
		-- else
		-- 	fast_event_notify(stderr, vim.log.levels.ERROR)
		-- end
	end
end

function M.easy_cmd(cmd)
	if type(cmd) == "string" then
		-- for now assume that any command passed as a string is trivially splitable by ' '
		-- something like "echo 'print this'" would not work
		cmd = M.split(cmd, " ")
	else
		if type(cmd) ~= "table" then
			vim.notify(string.format("Command %s is of an invalid type %s", cmd, type(cmd)), vim.log.levels.ERROR)
			return
		end
	end
	vim.system(cmd, { text = true }, on_exit)
end

return M
