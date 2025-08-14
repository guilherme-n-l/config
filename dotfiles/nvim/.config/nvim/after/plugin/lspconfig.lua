local lspconfig = require("lspconfig")
local conform = require("conform")

local lsps = {
	lua = {
		name = "lua_ls",
		cmd = { "lua-lsp" },

		fmts = { "stylua" },
		fmts_args = { { prepend_args = { "--syntax", "Lua52" } } },
	},
	nix = {
		name = "nil_ls",
		cmd = { "nil" },

		fmts = { "alejandra" },
	},
	rust = {
		health = "rustc --version",
		name = "rust_analyzer",
		cmd = { "rust-analyzer" },

		fmts = { "rustfmt" },
	},
	python = {
		health = "python3 --version",
		name = "pylsp",

		fmts = { "black" },
	},
	c = {
		health = "gcc --version || clang --version",
		name = "clangd",

		fmts = { "clang-format" },
	},
	typst = {
		health = "tinymist --version",
		name = "tinymist",

		fmts = { "typstfmt" },
	},
}

local conform_config = { formatters_by_ft = {} }
-- local cmp_nvim_capabilities = cmp_nvim.default_capabilities()
for k, lsp in pairs(lsps) do
	if lsp.health and os.execute(lsp.health) ~= 0 then
		goto continue
	end

	lspconfig[lsp.name].setup({
		cmd = lsp.cmd or { lsp.name },
		on_attach = function()
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
				},
			}

			for k, v in pairs(mappings) do
				for _, m in ipairs(v) do
					vim.keymap.set(k, unpack(m))
				end
			end
		end,
	})

	if not lsp.fmts then
		goto continue
	end

	for i, fmt in ipairs(lsp.fmts) do
		if lsp.fmts_args and lsp.fmts_args[i] then
			conform.formatters[fmt] = lsp.fmts_args[i]
		else
			conform.formatters[fmt] = {}
		end
		conform.formatters[fmt].command = conform.formatters[fmt].command or fmt
	end

	conform_config.formatters_by_ft[k] = lsp.fmts
	::continue::
end

conform.setup(conform_config)

vim.diagnostic.config({ virtual_text = false })
