return {
	"benlubas/molten-nvim",
	version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
	dependencies = { "3rd/image.nvim" },
	build = ":UpdateRemotePlugins",
	init = function()
		local extras = require("myutils.extras")

		extras.map("n", "<leader>mi", function()
			local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
			if venv ~= nil then
				-- in the form of /home/benlubas/.virtualenvs/VENV_NAME
				venv = string.match(venv, "/.+/(.+)")
				vim.cmd(("MoltenInit %s"):format(venv))
			else
				vim.cmd("MoltenInit")
			end
		end, { desc = "Initialize Molten" })
		extras.map("n", "<leader>mr", function()
			local start_line = vim.fn.search("^```\\(python\\|{python}\\)\\s*$", "bnW")
			if start_line == 0 then
				return
			end

			local end_line = vim.fn.search("^```\\s*$", "nW")
			if end_line == 0 then
				return
			end

			vim.api.nvim_win_set_cursor(0, { start_line + 1, 0 })
			vim.cmd("normal! V")
			vim.api.nvim_win_set_cursor(0, { end_line - 1, 0 })
			vim.cmd("normal! \27")
			vim.cmd("normal! gv")
			-- maybe better to call MoltenEvaluateArgument, which apparently accepts a string of code
			vim.cmd("MoltenEvaluateVisual")
			vim.cmd("normal! \27")
		end, { desc = "Run Notebook Cell" })
		extras.map("n", "<leader>mp", function()
			vim.api.nvim_put({ "```python", "", "```", "" }, "l", true, true)
			vim.api.nvim_win_set_cursor(0, { vim.api.nvim_win_get_cursor(0)[1] - 3, 0 })
			vim.cmd("startinsert")
		end, { desc = "Insert Python code block" })
		extras.map("n", "<leader>mo", function()
			vim.cmd("MoltenShowOutput")
			vim.cmd("noautocmd MoltenEnterOutput")
		end, { desc = "Show Cell Output" })
		extras.map("n", "<leader>mh", ":MoltenHideOutput<CR>", { desc = "Hide Cell Output" })
		extras.map("n", "<leader>md", ":MoltenDelete<CR>", { desc = "Delete Current Molten Cell" })
		extras.map("n", "<leader>mR", ":MoltenRestart!<CR>", { desc = "Restart Kernel" })

		-- these are examples, not defaults. Please see the readme
		vim.g.molten_image_provider = "image.nvim"
		vim.g.molten_output_win_max_height = 20
		vim.g.molten_auto_open_output = false
		vim.g.molten_virt_text_output = true
		vim.g.molten_output_show_more = true
	end,
}
