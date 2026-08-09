-- vim.o.autocomplete = true

vim.opt.completeopt = { "menuone", "noinsert", "fuzzy" }
vim.o.pumheight = 5
vim.o.pumborder = "rounded"

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client:supports_method("textDocument/completion") then
			local chars = {}
			for i = 97, 122 do -- a..z
				table.insert(chars, string.char(i))
			end
            table.insert(chars, '.')
			client.server_capabilities.completionProvider.triggerCharacters = chars
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end,
})
