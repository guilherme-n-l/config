local keys = {
	{
		"<leader>hm",
		function()
			require("harpoon").add_file()
		end,
		desc = "Add current filepath to list",
	},
	{
		"<leader>hn",
		function()
			require("harpoon.ui").nav_next()
		end,
		desc = "Navigate to next filepath in list",
	},
	{
		"<leader>hp",
		function()
			require("harpoon.ui").nav_prev()
		end,
		desc = "Navigate to prevous filepath in list",
	},
	{
		"<leader>hv",
		function()
			require("harpoon.ui").toggle_quick_menu()
		end,
		desc = "View list",
	},
}

for n = 1, 9 do
	table.insert(keys, {
		"<leader>" .. n,
		function()
			require("harpoon.ui").nav_file(n)
		end,
	})
end

return {
	"ThePrimeagen/harpoon",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = keys,
}
