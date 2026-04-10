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
	if g.colorscheme then
		vim.cmd("colorscheme " .. g.colorscheme)
		g.colorscheme = nil
	end
end

--- Function to set the colorscheme.
---@param name string The name of the colorscheme to apply.
function Colorscheme(name)
	g.colorscheme = name
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
					f()
				end
			end,
		})
		_after_flag = true
	end
	if fn then
		if type(fn) == "table" then
			_after_fns = vim.tbl_extend("force", _after_fns, fn)
		elseif type(fn) == "function" then
			table.insert(_after_fns, fn)
		end
	end
end
