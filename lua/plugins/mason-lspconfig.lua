-- Disabled: this was a second, independent lazy.nvim spec for mason-lspconfig.nvim,
-- separate from the one configured in plugins/lsp.lua. Both called
-- require("mason-lspconfig").setup(...), and this one's event = "BufReadPre" made it
-- fire *after* the eager one in lsp.lua, using mason-lspconfig's default
-- automatic_enable = true (no exclude list). That silently auto-enabled a second,
-- competing rust_analyzer LSP client on top of rustaceanvim's, even though lsp.lua's
-- own setup() call explicitly excludes rust_analyzer via automatic_enable.exclude.
-- Its own ensure_installed list was empty (fully commented out) anyway, so lsp.lua's
-- setup() is a strict superset. Kept commented above for reference.

--[[
local mason_lspconfig = {
	"williamboman/mason-lspconfig.nvim",
	opts = {
		ensure_installed = {
		--	"solidity_ls",
		--	"efm",
		--	"bashls",
		--	"tsserver",
		--	"tailwindcss",
		--	"pyright",
		--	"lua_ls",
		--	"emmet_ls",
		--	"jsonls",
		--	"clangd",
		--	"dockerls",
		},
		automatic_installation = true,
	},
	event = "BufReadPre",
	dependencies = "williamboman/mason.nvim",
}

return {
	mason_lspconfig,
}
]]

return {}
