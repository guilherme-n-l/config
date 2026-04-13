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
local _after_flags = {}

local function _queue(fn, event)
    event = event or "VimEnter"
    if not _after_flags[event] then
        _after_fns[event] = {}
        vim.api.nvim_create_autocmd(event, {
            callback = function()
                for _, f in ipairs(_after_fns[event]) do
                    pcall(f)
                end
            end,
        })
        _after_flags[event] = true
    end
    table.insert(_after_fns[event], fn)
end

--- Queue a function to be executed after a given autocmd event (default: VimEnter).
--- Accepts:
---   - a function: queued for VimEnter
---   - a list of functions: each queued for VimEnter
---   - a table of { [fn] = event }: each fn queued for its specified event
---@param fn fun()|table
function Do_after(fn)
    if type(fn) == "function" then
        _queue(fn)
    elseif type(fn) == "table" then
        for k, v in pairs(fn) do
            if type(k) == "number" then
                _queue(v)
            else
                _queue(k, v)
            end
        end
    end
end

--- Function to convert GitHub repository paths into full GitHub URLs.
--- Accepts either:
---   - a single string (e.g. "owner/repo")
---   - a list of strings (e.g. { "owner/repo", "user/project" })
--- Leading slashes are automatically stripped.
---
---@overload fun(tbl: string): string
---@overload fun(tbl: string[]): string[]
---@param tbl string|string[] A GitHub repo path or list of repo paths
---@return string|string[] Full GitHub URL or list of URLs
function Gh(tbl)
    local gh = function(s)
        return string.format("https://github.com/%s", s:gsub("^/+", ""))
    end
    return type(tbl) == "string" and gh(tbl) or vim.tbl_map(function(s)
        return gh(s)
    end, tbl --[[@as table]])
end

--- Requires and sets up packages.
--- Accepts a string, or a table where:
---   - string values are required and setup with no config
---   - key-value pairs are required by key and setup with value as config
---@param tbl string|table Package name or table of packages with optional configs
function Setup_packages(tbl)
    if type(tbl) == "string" then
        require(tbl).setup()
        return
    end
    for k, v in pairs(tbl) do
        if type(k) == "number" then
            require(v).setup()
        else
            require(k).setup(v)
        end
    end
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
