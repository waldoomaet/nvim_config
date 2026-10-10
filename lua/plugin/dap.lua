return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"mfussenegger/nvim-dap-python",
		"theHamsta/nvim-dap-virtual-text",
		"igorlfs/nvim-dap-view",
	},
	keys = {
		{ "<leader>db", "<cmd>DapToggleBreakpoint<cr>", desc = "Toggle breakpoint" },
		{
			"<leader>dc",
			function()
				if vim.bo.modified then
					vim.cmd("write")
                    print("saved")
                else
                    print("not saved")
				end

				vim.cmd("DapContinue")
			end,
			desc = "Continue/Run",
		},
		{ "<leader>dt", "<cmd>DapViewToggle<cr>", desc = "Toggle view" },
		{ "<leader>dw", "<cmd>DapViewWatch<cr>", desc = "View watch" },
		{
			"<leader>dd",
			function()
				local dap = require("dap")

				if dap.session() then
					vim.notify("Debug session active. Can't close dap-view-term", vim.log.levels.INFO)
					return
				end

				for _, buf in ipairs(vim.fn.tabpagebuflist()) do
					if vim.bo[buf].filetype == "dap-view-term" then
						vim.api.nvim_buf_delete(buf, { force = true })
					end
				end
			end,
			desc = "Close DAP terminal",
		},
		{
			"<Down>",
			function()
				local dap = require("dap")

				if dap.session() then
					dap.step_over()
				else
					vim.cmd("normal! j")
				end
			end,
			desc = "DAP Step Over / Down",
		},
		{
			"<Right>",
			function()
				local dap = require("dap")

				if dap.session() then
					dap.step_into()
				else
					vim.cmd("normal! l")
				end
			end,
			desc = "DAP Step Into / Right",
		},
	},
	config = function()
		local dap = require("dap")

		vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#ff0000" })
		vim.fn.sign_define("DapBreakpoint", {
			text = "●",
			texthl = "DapBreakpoint",
		})

		require("nvim-dap-virtual-text").setup()
		require("dap-view").setup({
			windows = {
				size = 0.25,
				position = "below",
				terminal = {
					size = 0.5,
					position = "left",
				},
			},
			auto_toggle = "open_term",
		})
		require("dap-python").setup("env/bin/python")
		local py_config = dap.configurations.python[1]
		dap.configurations.python = { py_config }
	end,
}
