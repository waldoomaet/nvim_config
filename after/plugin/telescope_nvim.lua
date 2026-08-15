local builtin = require('telescope.builtin')
local telescope = require("telescope")
local actions = require("telescope.actions")
local extras = require("myutils.extras")

telescope.setup({
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

extras.Map('n', '<leader>pf', builtin.find_files, { desc = 'Telescope find files' })
extras.Map('n', '<C-p>', builtin.git_files, {})
extras.Map('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
