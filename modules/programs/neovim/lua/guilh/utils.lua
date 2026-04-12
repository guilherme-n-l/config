unpack = table.unpack or unpack

--- Function to return the first element of a table.
---@param tbl table The table from which to extract the first element.
---@return any -- The first element of the table.
function Car(tbl)
    return tbl[1]
end

--- Function to return the tail (all elements except the first) of a table.
---@param tbl table The table from which to extract the tail.
---@return table -- A new table containing all elements except the first.
function Cdr(tbl)
    local tail = {}
    for i = 2, #tbl do
        table.insert(tail, tbl[i])
    end
    return tail
end

--- Function to load the colorscheme if it's been set.
function Load_colorscheme()
    if vim.g.colorscheme then
        vim.cmd("colorscheme " .. vim.g.colorscheme)
        vim.g.colorscheme = nil
    end
end

local _after_fns = {}
local _after_flag = false
--- Function to queue a function to be executed after VimEnter.
---@param fn fun()|table The function(s) to execute after VimEnter.
---   If a function is passed, it will be added to the queue.
---   If a table of functions is passed, all functions in the table will be added to the queue.
function Do_after(fn)
    if not _after_flag then
        vim.api.nvim_create_autocmd("VimEnter", {
            callback = function()
                for _, f in ipairs(_after_fns) do
                    pcall(f)
                end
            end,
        })
        _after_flag = true
    end
    if fn then
        if type(fn) == "table" then
            vim.list_extend(_after_fns, fn)
        elseif type(fn) == "function" then
            table.insert(_after_fns, fn)
        end
    end
end

--- Function to convert GitHub repository paths into full GitHub URLs.
--- Accepts either:
---   - a single string (e.g. "owner/repo")
---   - a list of strings (e.g. { "owner/repo", "user/project" })
--- Leading slashes are automatically stripped.
---
---@param tbl string|table A GitHub repo path or list of repo paths
---@return string|table Full GitHub URL or list of URLs
function Gh(tbl)
    local gh = function(s)
        return string.format("https://github.com/%s", s:gsub("^/+", ""))
    end
    return type(tbl) == "string" and gh(tbl) or vim.tbl_map(function(s)
        return gh(s)
    end, tbl)
end

--- Sets key mappings from a provided table.
---@param mappings table The key mappings to set.
function Set_keymaps(mappings)
    for k, v in pairs(mappings) do
        local mode = k
        if #k > 1 then
            mode = {}
            for i = 1, #k do
                table.insert(mode, k:sub(i, i))
            end
        end
        for _, m in ipairs(v) do
            local head = Car(m)
            local keys = type(head) == "table" and head or { head }
            local tail = Cdr(m)
            for _, km in ipairs(keys) do
                vim.keymap.set(mode, km, unpack(tail))
            end
        end
    end
end
