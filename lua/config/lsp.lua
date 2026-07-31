-- do not trigger autocomplete automatically.
vim.o.autocomplete = false

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    vim.lsp.completion.enable(true, ev.data.client_id, ev.buf, {
      autotrigger = false,
    })
  end,
})

-- trigger autocomplete options manually,
-- after 3 characters have been typed

-- this is here to avoid crashing with the insert mode Esc binding
vim.g.completion_cancelled = false

vim.api.nvim_create_autocmd('TextChangedI', {
  callback = function()
    if vim.g.completion_cancelled then
      vim.g.completion_cancelled = false
      return
    end

    local col = vim.fn.col('.') - 1
    if col < 3 then
      return
    end

    local line = vim.api.nvim_get_current_line()
    local prefix = line:sub(1, col):match('[%w_]+$')

    if prefix and #prefix >= 3 then
      vim.lsp.completion.get()
    end
  end,
})

vim.opt.complete:append('o')
vim.opt.completeopt = { 'menuone', 'noinsert', 'popup' }

vim.o.pumheight = 5
vim.o.pumborder = 'rounded'
