return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		preset = "helix",
	},
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)

		-- Register group prefixes so WhichKey labels sub-menus cleanly
		wk.add({
			{ "<leader>l", group = "LSP / Goto" },
			{ "<leader>p", group = "Telescope find" },
			{ "<leader>b", group = "Buffer" },
			{ "<leader>t", group = "Terminal" },
			{ "<leader>d", group = "Debug" },
			{ "<leader>u", group = "Wiki" },
		})
	end,
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Local Keymaps (which-key)",
		},
	},
}
