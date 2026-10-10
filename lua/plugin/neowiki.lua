return {
	"echaya/neowiki.nvim",

	opts = {
		wiki_dirs = {
			{
				name = "cwd",
				path = vim.fn.getcwd(),
			},
		},

		keymaps = {
			-- Link navigation
			action_link = "<CR>",
			action_link_vsplit = "<S-CR>",
			action_link_split = "<C-CR>",
			next_link = "<Tab>",
			prev_link = "<S-Tab>",
			navigate_back = "[[",
			navigate_forward = "]]",
			jump_to_index = "<Backspace>",

			-- NeoWiki actions: <leader>w -> <leader>u
			toggle_task = "<leader>ut",
			delete_page = "<leader>ud",
			rename_page = "<leader>ur",
			insert_link = "<leader>ui",
			cleanup_links = "<leader>uc",

			close_float = "q",
		},
	},
	keys = {
		{
			"<leader>uw",
			"<cmd>lua require('neowiki').open_wiki()<cr>",
			desc = "Open Wiki",
		},
		{
			"<leader>uW",
			"<cmd>lua require('neowiki').open_wiki_floating()<cr>",
			desc = "Open Wiki in Floating Window",
		},
		{
			"<leader>uT",
			"<cmd>lua require('neowiki').open_wiki_new_tab()<cr>",
			desc = "Open Wiki in Tab",
		},
	},
}
