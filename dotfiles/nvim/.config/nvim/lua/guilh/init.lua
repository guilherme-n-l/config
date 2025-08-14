require("guilh.lazy")
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
	undofile = true,

	termguicolors = true,

	scrolloff = 8,
	signcolumn = "yes",

	hlsearch = false,
	incsearch = true,

	winborder = "rounded",
	completeopt = { "menuone", "noselect", "popup" },
}

for k, v in pairs(opts) do
	vim.opt[k] = v
end

vim.api.nvim_create_user_command("TextMode", "set wrap | set spell | set spelllang=pt,en", {})
