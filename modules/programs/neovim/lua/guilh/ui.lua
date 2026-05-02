local M = {}

function M.transparent_bg()
    for _, hl in ipairs({
        "Normal",
        "NormalNC",
        "LineNr",
        "LineNrAbove",
        "LineNrBelow",
        "SignColumn",
        "GitSignsAdd",
        "GitSignsChange",
        "GitSignsDelete",
        "GitSignsTopdelete",
        "GitSignsChangedelete",
        "GitSignsUntracked",
    }) do
        local current = vim.api.nvim_get_hl(0, { name = hl, link = false }) --[[@as vim.api.keyset.highlight]]
        current.bg = nil
        vim.api.nvim_set_hl(0, hl, current)
    end
    vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "NONE", bold = true })
end

return M
