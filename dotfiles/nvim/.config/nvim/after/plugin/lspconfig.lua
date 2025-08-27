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
		health = "rust-analyzer --version",
		name = "rust_analyzer",
		cmd = { "rust-analyzer" },

		fmts = { "rustfmt" },
	},
	python = {
		health = "pylsp --version",
		name = "pylsp",
		lsp_args = {
			settings = {
				pylsp = {
					plugins = {
						pylint = { enabled = true, executable = "pylint" },
						black = { enabled = true },
						pyls_isort = { enabled = true },
						pylsp_mypy = { enabled = true },
					},
				},
			},
		},
		fmts = { "black", "isort" },
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
	markdown = {
		health = "marksman --version",
		name = "marksman",

		fmts = { "mdformat" },
	},
	typescript = {
		name = "ts_ls",
		cmd = { "typescript-language-server", "--stdio" },
		health = "typescript-language-server --version",

		fmts = { "prettier" },
	},
	javascript = {
		name = "ts_ls",
		cmd = { "typescript-language-server", "--stdio" },
		health = "typescript-language-server --version",

		fmts = { "prettier" },
	},
	perl = {
		name = "perlpls",
		cmd = { "pls" },
		health = "echo '' | pls",

		fmts = { "perltidy" },
	},
}

local conform_config = { formatters_by_ft = {} }
for k, lsp in pairs(lsps) do
	if lsp.health and os.execute(lsp.health) ~= 0 then
		goto continue
	end

	lspconfig[lsp.name].setup({
		cmd = lsp.cmd or { lsp.name },
		on_attach = function(client, bufnr)
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

			for k, v in pairs(mappings) do
				for _, m in ipairs(v) do
					vim.keymap.set(k, unpack(m))
				end
			end

			vim.lsp.completion.enable(true, client.id, bufnr, {
				autotrigger = true,
				convert = function(item)
					return { abbr = item.label:gsub("%b()", "") }
				end,
			})
		end,
	})

	if not lsp.fmts then
		goto continue
	end

	for i, fmt in ipairs(lsp.fmts) do
		conform.formatters[fmt] = {}

		if lsp.fmts_args and lsp.fmts_args[i] then
			conform.formatters[fmt] = lsp.fmts_args[i]
		end

		conform.formatters[fmt].command = conform.formatters[fmt].command or fmt
	end

	conform_config.formatters_by_ft[k] = lsp.fmts
	::continue::
end

conform.setup(conform_config)

vim.diagnostic.config({ virtual_text = false })
