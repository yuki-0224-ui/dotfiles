require("lazydev").setup()

require("ddc_source_lsp_setup").setup()
local capabilities = require("ddc_source_lsp").make_client_capabilities()

local lspconfig = require("lspconfig")

local servers = {
	"lua_ls",
	"taplo",
}

-- Auto start language servers.
for _, name in ipairs(servers) do
	lspconfig[name].setup({})
end

-- LSP settings
local function on_attach(client, bufnr)
	local opts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
	vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
	vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, opts)
end

-- Deno Language Server の設定
lspconfig.denols.setup({
	root_dir = function(fname)
		local root = lspconfig.util.root_pattern("deno.json", "deno.jsonc", "deps.ts", ".git")(fname)
		return root or vim.fn.getcwd()
	end,
	init_options = {
		lint = true,
		unstable = true,
		suggest = {
			imports = {
				hosts = {
					["https://deno.land"] = true,
					["https://x.nest.land"] = true,
					["https://crux.land"] = true,
				},
			},
		},
	},
	on_attach = on_attach,
	filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
	single_file_support = true,
})

vim.lsp.set_log_level("debug")

-- lsp keymaps
vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
vim.keymap.set("n", "gf", "<cmd>lua vim.lsp.buf.format()<CR>")
vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
vim.keymap.set("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
vim.keymap.set("n", "gn", "<cmd>lua vim.lsp.buf.rename()<CR>")

-- vim.keymap.set('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>')

vim.keymap.set("n", "ge", "<cmd>lua vim.diagnostic.open_float()<CR>")
vim.keymap.set("n", "g]", "<cmd>lua vim.diagnostic.goto_next()<CR>")
vim.keymap.set("n", "g[", "<cmd>lua vim.diagnostic.goto_prev()<CR>")

vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
