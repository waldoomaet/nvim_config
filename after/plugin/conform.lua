local conform = require("conform")

conform.setup({
	formatters_by_ft = {
		lua = { "stylua" },
		yaml = { "prettier" },
		json = { "prettier" },
		xml = { "xmlformatter" },
		java = { "ast-grep" },
	},
})

vim.keymap.set("n", "<leader>f", function()
	conform.format({ lsp_format = "fallback", async = true })
end, { remap = false, silent = true })
