Config = vim.fn.resolve(vim.fn.stdpath("config"))
User = os.getenv("USER")
Userconfig = Config .. "/lua/" .. User
Lspconfig = Config .. "/lua/" .. User .. "/lsp"

local g = vim.g
local lazy_fn
local lazy_module_name = "lazy"
---@diagnostic disable-next-line: deprecated
local unpack = table.unpack or unpack

--- Function to set the colorscheme.
---@param name string The name of the colorscheme to apply.
function Colorscheme(name)
	g.colorscheme = name
end

--- Function to require a module based on the user's name.
---@param name string The name of the module to load.
---@return unknown: The required module.
---@return unknown: The loader data.
function Use(name)
	return require(User .. "." .. name)
end

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

--- Function to strip the leading prefix from a string.
---@param s string The string to strip.
---@param prefix string The prefix to remove.
---@return string -- The string with the prefix removed.
---@return integer -- The count with the prefix removed.
function Strip_leading(s, prefix)
	return s:gsub("^" .. prefix, "")
end

--- Function to strip the trailing suffix from a string.
---@param s string The string to strip.
---@param suffix string The suffix to remove.
---@return string -- The string with the suffix removed.
---@return integer -- The count with the suffix removed.
function Strip_trailing(s, suffix)
	return s:gsub(suffix .. "$", "")
end

--- Internal function to get the module path based on the current file's location.
---@return string -- The module path.
local function _get_module_path()
	local path = vim.fn.resolve(vim.fs.dirname(debug.getinfo(3, "S").short_src))
	if path == Config then
		path = Userconfig
	end
	return path
end

--- Internal function to get Lua files (excluding init.lua) from a given directory.
---@param path string The directory to search for Lua files.
---@param fn fun(name: string) -- The function to call for each found module.
local function _get_cwd_modules(path, fn)
	local lua_files =
		vim.fn.systemlist(string.format("find %s -maxdepth 1 -type f -name '*.lua' ! -name 'init.lua' -print", path))
	for _, f in ipairs(lua_files) do
		local module_name = Strip_leading(Strip_trailing(f, ".lua"), Userconfig .. "/"):gsub("/", ".")
		fn(module_name)
	end
end

--- Internal function to get directories containing init.lua (modules).
---@param path string The directory to search for module directories.
---@param fn fun(name: string) The function to call for each found directory.
local function _get_cwd_dir_modules(path, fn)
	local lua_dirs =
		vim.fn.systemlist(string.format("find %s -mindepth 2 -maxdepth 2 -type f -name 'init.lua' -print", path))
	for _, d in ipairs(lua_dirs) do
		local dir_name = Strip_leading(vim.fs.dirname(d), Userconfig .. "/"):gsub("/", ".")
		fn(dir_name)
	end
end

--- Internal function to set up lazy loading if required.
local function _set_lazy()
	lazy_fn = function()
		Use(lazy_module_name)
		lazy_fn = nil
	end
end

local _ignored_root_modules = { lazy_module_name }
--- Internal function to load Lua modules from the current directory.
---@param path string The path to the directory from which to load modules.
local function _load_cwd_modules(path)
	local is_root = path == Userconfig
	_get_cwd_modules(path, function(f)
		if not is_root then
			Use(f)
		else
			if not vim.tbl_contains(_ignored_root_modules, f) then
				Use(f)
			elseif f == lazy_module_name then
				_set_lazy()
			end
		end
	end)
end

local _ignored_root_dir_modules = {}
--- Internal function to load Lua modules from directories containing init.lua.
---@param path string The path to the directory from which to load modules.
local function _load_cwd_dir_modules(path)
	_get_cwd_dir_modules(path, function(d)
		if not vim.tbl_contains(_ignored_root_dir_modules, d) then
			Use(d)
		end
	end)
end

--- Function to load all modules in the current user's config directory.
function Load_modules()
	local path = _get_module_path()
	_load_cwd_modules(path)
	_load_cwd_dir_modules(path)
	if lazy_fn then
		lazy_fn()
	end
end

--- Function to enable LSP completion for a given buffer.
---@param id integer The LSP client ID.
---@param bufnr integer The buffer number for which to enable completion.
local function _lsp_completion_enable(id, bufnr)
	vim.lsp.completion.enable(true, id, bufnr, {
		autotrigger = true,
		convert = function(item)
			return { abbr = item.label:gsub("%b()", "") }
		end,
	})
end

local _lsp_attach = function(c, bufnr)
	_lsp_completion_enable(c.id, bufnr)
end
--- Function to load LSP configurations from the user's LSP config directory.
function Load_lsps()
	_get_cwd_modules(Lspconfig, function(f)
		local config_name = Strip_leading(f, "lsp.")
		vim.lsp.config(config_name, vim.tbl_extend("force", Use(f), { on_attach = _lsp_attach }))
		vim.lsp.enable(config_name)
	end)
	vim.lsp.completion.enable()
end

--- Function to load the colorscheme if it's been set.
function Load_colorscheme()
	if g.colorscheme then
		vim.cmd("colorscheme " .. g.colorscheme)
		g.colorscheme = nil
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
