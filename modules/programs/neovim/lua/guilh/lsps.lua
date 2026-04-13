local enable = vim.lsp.enable

enable({
	"lua_ls",
	"nixd",
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		local bufnr = args.buf

		if not client then
			return
		end

		vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
	end,
})
