require("config.remap")
require("config.lsp")

vim.g.mapleader = " " -- Set the <Leader> key to Space

vim.opt.spell = true
vim.opt.spelllang = { "en_us" }

vim.o.exrc = true
vim.opt.clipboard = "unnamedplus"

vim.opt.nu = true    -- Enable line numbers
vim.wo.number = true -- Enable line numbers for the current window

local tabsize = 4
vim.opt.tabstop = tabsize     -- Display a tab character as 'tabsize' spaces wide
vim.opt.softtabstop = tabsize -- Make Tab/Backspace behave as if tabs are 'tabsize' spaces
vim.opt.shiftwidth = tabsize  -- Use 'tabsize' spaces for each indentation level

vim.opt.expandtab = true      -- Convert tabs into spaces
vim.smartindent = true        -- Automatically insert indentation in some cases

-- vim.opt.colorcolumn = "120"   -- Display a guide line at column 120
vim.opt.wrap = true      -- Wrap long lines instead of extending off-screen
vim.opt.linebreak = true -- Wrap lines at word boundaries instead of splitting words
vim.opt.whichwrap:append("<,>,[,]")

vim.opt.hlsearch = true  -- Do not highlight all search matches after searching
vim.opt.incsearch = true -- Show search matches incrementally while typing

vim.opt.swapfile = false -- Disable swap files
vim.opt.backup = false   -- Disable backup files
vim.opt.undofile = true  -- Enable persistent undo history

-- Comment this line
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
-- Store undo history files in ~/.vim/undodir (Linux/macOS)

-- And uncomment this one in case you use Windows
-- vim.opt.undodir = os.getenv("UserProfile") .. "/.vim/undodir"
-- Store undo history files in %UserProfile%\.vim\undodir (Windows)

vim.opt.scrolloff = 12     -- Keep at least 8 lines visible above/below the cursor
vim.opt.signcolumn = "yes" -- Always show the sign column (for diagnostics, git signs, etc.)
vim.opt.updatetime = 100   -- Faster update time for plugins and CursorHold events (100 ms)

vim.opt.fillchars = {
    eob = " ", -- Hide '~' characters after the end of the buffer
    vert = "│", -- Use a vertical bar for window separators
    fold = " ", -- Use spaces to fill folded lines
    diff = "╱", -- Character used in diff mode filler lines
}
