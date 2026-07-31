vim.g.mapleader = " "

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set('n', 'gl', vim.diagnostic.open_float)

vim.keymap.set('i', '<Esc>', function()
  if vim.fn.pumvisible() == 1 then
    vim.g.completion_cancelled = true

    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes('<C-e>', true, false, true),
      'i',
      false
    )
  else
    vim.cmd('stopinsert')
  end
end, { desc = 'Close completion popup or leave insert mode' })

vim.keymap.set("i", "<Tab>", function()
  if vim.fn.pumvisible() == 1 then
     -- accept that option
     return vim.api.nvim_replace_termcodes("<C-y>", true, false, true)
  end
  return "<Tab>"
end, { expr = true }, { desc = 'Choose the currently focused autocomplete ouption' })
