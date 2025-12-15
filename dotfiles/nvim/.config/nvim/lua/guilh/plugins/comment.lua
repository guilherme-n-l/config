local mappings = { line = " ;", block = " b;" }
return {
	"numToStr/Comment.nvim",
	lazy = false,
	config = function()
		require("Comment").setup({
			padding = true,
			sticky = true,
			ignore = nil,
			toggler = mappings,
			opleader = mappings,
			mappings = { basic = true },
			pre_hook = nil,
			post_hook = nil,
		})
	end,
}
