require("guilh.lazy")
require("guilh.functions")
require("guilh.remaps")

local opts = {
	nu = true,
	rnu = true,
	wrap = false,

	guicursor = "",

	tabstop = 4,
	softtabstop = 4,
	shiftwidth = 4,
	expandtab = true,
	smartindent = true,

	swapfile = false,
	backup = false,

	termguicolors = true,

	scrolloff = 8,
	signcolumn = "yes",

	hlsearch = false,
	incsearch = true,

    winborder = "rounded",
}

for k, v in pairs(opts) do
	vim.opt[k] = v
end
