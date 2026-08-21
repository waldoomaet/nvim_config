return {
    "mason-org/mason-lspconfig.nvim",
    opts = {
        -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
        -- :help lspconfig-all
        ensure_installed = { "lua_ls", "pyright", "rust_analyzer", "clangd", "csharp_ls", "jdtls", "shuck", "html", "ts_ls" },
    },
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
    },
}
