local M = {}

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
end

return M
