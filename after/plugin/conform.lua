local conform = require("conform")
local extras = require("myutils.extras")

function Install_Formatters(config)
	local lazyConfig = require("lazy.core.config")

	if lazyConfig.plugins["mason.nvim"] then
		local ok, registry = pcall(require, "mason-registry")

		if ok then
			local tools = {}

			for _, filetype_tools in pairs(config) do
				for _, tool in ipairs(filetype_tools) do
					tools[tool] = true
				end
			end

			for linter, _ in pairs(tools) do
				local package = registry.get_package(linter)
				if not package:is_installed() then
					vim.notify("Formatter " .. linter .. " is missing, installing...", vim.log.levels.WARN)
					package:install()
				end
			end
		end
	end
end

local config = {
	lua = { "stylua" },
	yaml = { "prettier" },
	json = { "prettier" },
	xml = { "xmlformatter" },
	java = { "ast-grep" },
}

Install_Formatters(config)

conform.setup({
	formatters_by_ft = config,
})

extras.Map("n", "<leader>f", function()
	conform.format({ lsp_format = "fallback", async = true })
end)
