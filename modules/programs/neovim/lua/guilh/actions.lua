local M = {}

local diagnostics_ns = vim.api.nvim_create_namespace("diagnostics_preview")

function M.pick(arg)
    return string.format("<cmd>Pick %s<cr>", arg)
end

function M.diagnostics()
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
        vim.diagnostic.open_float({ scope = "cursor" })
    end

    local preview = function(buf_id, item)
        local start = math.max(item.value.lnum - 10, 0)
        local lines = vim.api.nvim_buf_get_lines(bufnr, start, item.value.end_lnum + 10, false)
        vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, lines)
        local ft = vim.bo[bufnr].filetype
        vim.bo[buf_id].filetype = ft
        local highlighted = item.value.lnum - start
        vim.api.nvim_buf_set_extmark(buf_id, diagnostics_ns, highlighted, 0, {
            end_row = highlighted,
            end_col = #lines[highlighted + 1],
            hl_group = "MiniPickPreviewRegion",
        })
    end

    require("mini.pick").start({
        source = { items = items, name = "Diagnostics", choose = point_to, preview = preview },
    })
end

function M.completion()
    local current_clients = vim.lsp.get_clients({ bufnr = 0 })
    for _, c in ipairs(current_clients) do
        if c.server_capabilities.completionProvider then
            vim.lsp.completion.get()
            return
        end
    end
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-n>", true, false, true), "n", true)
end

return M
