local function pick(arg)
	return string.format("<cmd>Pick %s<cr>", arg)
end

local function diagnostics()
	local diagnostic_tbl = vim.diagnostic.get(0)
	table.sort(diagnostic_tbl, function(a, b)
		return a.lnum < b.lnum
	end)
	local items = {}
	for _, diagnostic in ipairs(diagnostic_tbl) do
		local severity_icon = {
			[vim.diagnostic.severity.ERROR] = "❌",
			[vim.diagnostic.severity.WARN] = "⚠️",
			[vim.diagnostic.severity.INFO] = "ℹ️",
			[vim.diagnostic.severity.HINT] = "💡",
		}

		local display_text = string.format(
			"%s[%d:%d] %s",
			severity_icon[diagnostic.severity] or "⁉️",
			diagnostic.lnum + 1,
			diagnostic.col + 1,
			diagnostic.message
		)

		table.insert(items, {
			text = display_text,
			value = diagnostic,
		})
	end

	local current_win = vim.api.nvim_get_current_win()
	local bufnr = vim.api.nvim_get_current_buf()

	local point_to = function(item)
		local diagnostic = item.value
		vim.api.nvim_win_set_cursor(current_win, { diagnostic.lnum + 1, diagnostic.col + 1 })
	end

	local preview = function(buf_id, item)
		local start = math.max(item.value.lnum - 10, 0)
		local lines = vim.api.nvim_buf_get_lines(bufnr, start, item.value.end_lnum + 10, false)
		vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, lines)
		local highlighted = item.value.lnum - start
		vim.api.nvim_buf_add_highlight(buf_id, -1, "MiniPickPreviewRegion", highlighted, 0, #lines[highlighted + 1])
	end

	require("mini.pick").start({
		source = { items = items, name = "Diagnostics", choose = point_to, preview = preview },
	})
	vim.defer_fn(function()
		vim.diagnostic.open_float({ scope = "cursor" })
	end, 0)
end

return {
	"nvim-mini/mini.pick",
	version = false,
	config = function()
		require("mini.pick").setup()
	end,
	keys = {
		{ "<leader>pf", pick("files"), desc = "Fuzzy find files" },
		{ "<leader>pg", pick("grep_live"), desc = "Fuzzy find strings recursively" },
		{ "<leader>ph", pick("help"), desc = "Fuzzy find help" },

		{ "<leader>xv", diagnostics },
	},
}
