local lsps = {}
lsps.lua = {
	name = "lua_ls",
	cmd = { "lua-lsp" },

	fmts = { "stylua" },
	fmts_args = { { prepend_args = { "--syntax", "Lua52" } } },
}
lsps.go = {
	name = "gopls",
	fmts = { "gofmt" },
}
lsps.nix = {
	name = "nil_ls",
	cmd = { "nil" },

	fmts = { "alejandra" },
}
lsps.rust = {
	health = "rust-analyzer --version",
	name = "rust_analyzer",
	cmd = { "rust-analyzer" },
	lsp_args = {
		settings = {
			["rust-analyzer"] = {
				check = { command = "clippy" },
			},
		},
	},

	fmts = { "rustfmt" },
}
lsps.python = {
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
}
lsps.c = {
	health = "clangd --version",
	name = "clangd",

	fmts = { "clang-format" },
}
lsps.typst = {
	health = "tinymist --version",
	name = "tinymist",

	fmts = { "typstfmt" },
}
lsps.markdown = {
	health = "marksman --version",
	name = "marksman",

	fmts = { "mdformat" },
}
lsps.typescript = {
	name = "ts_ls",
	cmd = { "typescript-language-server", "--stdio" },
	health = "typescript-language-server --version",

	fmts = { "prettier" },
}
lsps.javascript = {
	name = "ts_ls",
	cmd = { "typescript-language-server", "--stdio" },
	health = "typescript-language-server --version",

	fmts = { "prettier" },
}
lsps.perl = {
	name = "perlpls",
	cmd = { "pls" },
	health = "echo '' | pls",

	fmts = { "perltidy" },
}

return lsps
