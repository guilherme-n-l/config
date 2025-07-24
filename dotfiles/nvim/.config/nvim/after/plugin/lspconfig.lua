local vim = vim
local lsp_zero = require("lsp-zero")
local lspconfig = require("lspconfig")

local cmp = require("cmp")
local cmp_action = require("lsp-zero").cmp_action()
local conform = require("conform")
local cmp_icons = {
	Variable = "",
	Keyword = "",
	Text = "",
	Property = "󰩊",
	Function = "󰡱",
	Snippet = "",
	Module = "",
	Class = "󰝻",
	Struct = "",
	Constructor = "",
	Field = "",
	Enum = "",
	EnumMember = "",
	Interface = "",
}

------------------------------
--          Cmp             --
------------------------------

cmp.setup({
	window = {
		completion = cmp.config.window,
		documentation = cmp.config.window,
		sources = cmp.config.sources({
			{ name = "nvim_lsp" },
		}, {
			{ name = "buffer" },
		}),
	},
	view = {
		entries = { name = "custom", selection_order = "near_cursor" },
		docs = {
			auto_open = false,
		},
	},
	formatting = {
		format = function(_, vim_item)
			local icon = (cmp_icons[vim_item.kind] or "") .. " "
			vim_item.kind = icon .. vim_item.kind
			return vim_item
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-f>"] = cmp_action.luasnip_jump_forward(),
		["<C-b>"] = cmp_action.luasnip_jump_backward(),
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
		["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
		["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		-- ['<C-c>'] = cmp.mapping.complete(),
		-- ["<C-y>"] = cmp.mapping.confirm(),
		["<C-l>"] = cmp.mapping.open_docs(),
		["<C-h>"] = cmp.mapping.close_docs(),
		["<C-k>"] = cmp.mapping.scroll_docs(-4),
		["<C-j>"] = cmp.mapping.scroll_docs(4),
	}),
})

------------------------------
--        Lsp_zero          --
------------------------------

lsp_zero.preset("recommended")

local signs = { Error = " ", Warn = " ", Hint = " ", Info = "󰙎 " }

lsp_zero.set_preferences({
	suggest_lsp_servers = false,
	sign_icons = {
		error = signs.Error,
		warn = signs.Warn,
		hint = signs.Hint,
		info = signs.Info,
	},
})

for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, guibg = "none" })
	vim.cmd(string.format("highlight %s guibg=none", hl))
end

lsp_zero.on_attach(function(_, bufnr)
	local opts = { buffer = bufnr, remap = false }
	vim.keymap.set("n", "gd", function()
		vim.lsp.buf.definition()
	end, opts)
	vim.keymap.set("n", "K", function()
		vim.lsp.buf.hover()
	end, opts)
	vim.keymap.set("n", "<leader>vca", function()
		vim.lsp.buf.code_action()
	end, opts)
	vim.keymap.set("n", "<leader>vrr", function()
		vim.lsp.buf.references()
	end, opts)
	vim.keymap.set("n", "<leader>vrn", function()
		vim.lsp.buf.rename()
	end, opts)
	vim.keymap.set("i", "<C-h>", function()
		vim.lsp.buf.signature_help()
	end, opts)
end)

lsp_zero.setup()

------------------------------
--        LSP CONFIG        --
------------------------------

local lsps = {
	lua = {
		name = "lua_ls",
		exec = "lua-lsp",

		fmts = { "stylua" },
		fmts_args = { { prepend_args = { "--syntax", "Lua52" } } },
	},
	nix = {
		name = "nil_ls",
		exec = "nil",

		fmts = { "alejandra" },
	},
	rust = {
		health = "rustc --version",
		name = "rust_analyzer",
		exec = "rust-analyzer",

		fmts = { "rustfmt" },
	},
	python = {
		health = "python3 --version",
		name = "pylsp",

		fmts = { "black" },
	},
}

local conform_config = { formatters_by_ft = {} }
for k, lsp in pairs(lsps) do
	if lsp.health and os.execute(lsp.health) ~= 0 then
		goto continue
	end

	lspconfig[lsp.name].setup({ cmd = { lsp.exec or lsp.name } })

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
