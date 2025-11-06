local lspconfig = require("lspconfig")
local conform = require("conform")
local lsps = dofile(vim.fn.stdpath('config') .. '/after/plugin/lsps.lua')

local conform_config = { formatters_by_ft = {} }

local mappings = {
	n = {
		{ "gd", vim.lsp.buf.definition },
		{ "K", vim.lsp.buf.hover },
		{ "<leader>vca", vim.lsp.buf.code_action },
		{ "<leader>vrr", vim.lsp.buf.references },
		{ "<leader>vrn", vim.lsp.buf.rename },
	},
	i = {
		{ "<C-h>", vim.lsp.buf.signature_help },
		{ "<C-n>", vim.lsp.completion.get },
	},
}

--- Loads LSP key mappings.
local function load_mappings()
	for k, v in pairs(mappings) do
		for _, m in ipairs(v) do
			vim.keymap.set(k, unpack(m))
		end
	end
end

--- Enables LSP completion for a client and buffer.
--- @param client table The LSP client.
--- @param bufnr number The buffer number.
local function load_enable_completion(client, bufnr)
	vim.lsp.completion.enable(true, client.id, bufnr, {
		autotrigger = true,
		convert = function(item)
			return { abbr = item.label:gsub("%b()", "") }
		end,
	})
end

--- Loads LSP and formatters for a given file type.
--- @param ft string The file type.
local function load_lsp_by_ft(ft)
	lsp = lsps[ft]

	if lsp.health and os.execute(lsp.health .. " &> /dev/null") ~= 0 then
		return
	end

	lsp_config = { cmd = lsp.cmd or { lsp.name } }

	if lsp.lsp_args then
		lsp_config = vim.tbl_deep_extend("force", lsp_config, lsp.lsp_args)
	end

	lspconfig[lsp.name].setup(lsp_config)

	if not lsp.fmts then
		return
	end

	for i, fmt in ipairs(lsp.fmts) do
		conform.formatters[fmt] = {}

		if lsp.fmts_args and lsp.fmts_args[i] then
			conform.formatters[fmt] = lsp.fmts_args[i]
		end

		conform.formatters[fmt].command = conform.formatters[fmt].command or fmt
	end

	conform_config.formatters_by_ft[ft] = lsp.fmts
	conform.setup(conform_config)
end

--- Creates an autocmd to load LSP for a file type.
--- @param ft string The file type.
local function lsp_autocmd_by_ft(ft)
	vim.api.nvim_create_autocmd("FileType", {
		pattern = ft,
		callback = function()
			load_lsp_by_ft(ft)
		end,
	})
end

--- Callback when LSP attaches to a buffer, loads mappings and completion.
--- @param client table The LSP client.
--- @param bufnr number The buffer number.
local function on_attach(client, bufnr)
	load_mappings()
	load_enable_completion(client, bufnr)
end

for ft, lsp in pairs(lsps) do
	lsp_autocmd_by_ft(ft)
	lspconfig[lsp.name].setup({ on_attach = on_attach })
end

conform.setup(conform_config)

vim.diagnostic.config({ virtual_text = false })
