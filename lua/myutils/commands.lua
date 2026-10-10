local M = {}

local evince_job

function M.setup()
	vim.api.nvim_create_user_command("ConfigOpen", function()
		vim.fn.jobstart({
			"kitty",
			"--directory",
			vim.fn.expand("~/.config/nvim"),
			"--start-as=maximized",
			"--class=nvim",
			"--",
			"/usr/bin/nvim",
			".",
		}, { detach = true })
	end, {})

	vim.api.nvim_create_user_command("ConfigTodo", function()
		vim.cmd("tabnew " .. vim.fn.expand("~/.config/nvim/todos.md"))
	end, {})

	vim.api.nvim_create_user_command("PdfOpen", function(opts)
		local pdf = vim.fn.expand(opts.args)

		if not vim.uv.fs_stat(pdf) then
			vim.notify("PDF not found: " .. pdf, vim.log.levels.ERROR)
			return
		end

		vim.system({ "evince", pdf }, {
			detach = true,
		})
	end, {
		nargs = 1,
		complete = function()
			local files = {}

			for name, type in vim.fs.dir(".") do
				if type == "file" and name:match("%.pdf$") then
					table.insert(files, name)
				end
			end

			return files
		end,
	})

	vim.api.nvim_create_autocmd("VimLeavePre", {
		callback = function()
			if evince_job then
				vim.fn.jobstop(evince_job)
			end
		end,
	})
end

return M
