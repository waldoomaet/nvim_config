local builtin = require("telescope.builtin")
local telescope = require("telescope")
local actions = require("telescope.actions")
local extras = require("myutils.extras")

telescope.setup({
	pickers = {
		find_files = {
			hidden = true,
		},
	},
	defaults = {
		mappings = {
			i = {
				["<S-CR>"] = actions.select_tab,
			},
			n = {
				["<S-CR>"] = actions.select_tab,
			},
		},
	},
})

extras.map("n", "<leader>pf", builtin.find_files, { desc = "Telescope find files" })
extras.map("n", "<C-p>", builtin.git_files, { desc = "Telescope Git files" })
extras.map("n", "<leader>ps", function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end, { desc = "Telescope grep files" })
