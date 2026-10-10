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

		extras.map("n", "<leader>le", vim.diagnostic.open_float, { desc = "Show diagnostics" })
		extras.map("n", "<leader>ld", vim.lsp.buf.definition, { desc = "Go to definition" })
		extras.map("n", "<leader>li", vim.lsp.buf.implementation, { desc = "Go to implementation" })
		extras.map("n", "<leader>lD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
		extras.map("n", "<leader>lr", vim.lsp.buf.references, { desc = "Find references" })
		extras.map("n", "<leader>ly", vim.lsp.buf.hover, { desc = "Show documentation" })
		extras.map("n", "<leader>ln", vim.lsp.buf.rename, { desc = "Rename symbol" })
		-- extras.map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })

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
