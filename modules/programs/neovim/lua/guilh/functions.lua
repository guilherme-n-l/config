local create = vim.api.nvim_create_user_command

local function get_visual_files()
    local oil = require("oil")
    local dir = oil.get_current_dir()
    if not dir then
        return {}
    end

    local start = vim.fn.line("'<")
    local finish = vim.fn.line("'>")

    if start == 0 or finish == 0 then
        return {}
    end

    if start > finish then
        start, finish = finish, start
    end

    local files = {}

    for lnum = start, finish do
        local entry = oil.get_entry_on_line(0, lnum)
        if entry and entry.name ~= ".." then
            files[#files + 1] = vim.fn.shellescape(dir .. entry.name)
        end
    end

    return files
end

create("OilBang", function(opts)
    if vim.bo.filetype ~= "oil" then
        vim.notify("OilBang must be run from an Oil buffer", vim.log.levels.ERROR)
        return
    end

    local oil = require("oil")
    local dir = oil.get_current_dir()

    local cmd = opts.args
        :gsub("%%%.", vim.fn.shellescape(dir))
        :gsub("%%f", table.concat(get_visual_files(), " "))

    vim.cmd("!" .. cmd)
end, { nargs = "+", range = true })
