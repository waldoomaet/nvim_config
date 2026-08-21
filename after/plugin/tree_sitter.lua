-- https://github.com/nvim-treesitter/nvim-treesitter/blob/main/SUPPORTED_LANGUAGES.md
require('nvim-treesitter').install { 'c', 'cpp', 'c_sharp', 'javascript', 'typescript', 'python', 'lua', 'yaml', 'json', 'html' }

vim.api.nvim_create_autocmd("FileType", {
    callback = function()
        pcall(vim.treesitter.start)
    end,
})
