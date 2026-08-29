-- vim.o.autocomplete = true
local extras = require("myutils.extras")

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
			table.insert(chars, ".")
			client.server_capabilities.completionProvider.triggerCharacters = chars
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end

		extras.map("n", "ge", vim.diagnostic.open_float)
		extras.map("n", "gd", vim.lsp.buf.definition) -- Go to definition
        extras.map("n", "gi", vim.lsp.buf.implementation)
        extras.map("n", "gD", vim.lsp.buf.declaration)
		extras.map("n", "gr", vim.lsp.buf.references) -- Find references
		extras.map("n", "gd", vim.lsp.buf.hover) -- Show documentation
		extras.map("n", "<leader>rn", vim.lsp.buf.rename) -- Rename symbol
		extras.map("n", "<leader>ca", vim.lsp.buf.code_action) -- Code actions

		extras.map("i", "<Tab>", function()
			if vim.fn.pumvisible() == 1 then
				return "<C-n>"
			end
			return "<Tab>"
		end, { expr = true, desc = "Cycle autocomplete options" })

		extras.map("i", "<S-Tab>", function()
			if vim.fn.pumvisible() == 1 then
				return "<C-p>"
			end
			return "<S-Tab>"
		end, { expr = true, desc = "Cycle autocomplete options" })
	end,
})
