local Utils = {}

local virtual_text_state = false

--- Toggles the display of virtual text for diagnostics.
function Utils.toggle_virtual_text()
	virtual_text_state = not virtual_text_state
	if virtual_text_state then
		vim.diagnostic.config({
			virtual_text = true,
		})
	else
		vim.diagnostic.config({
			virtual_text = false,
		})
	end
end

--- Sets key mappings from a provided table.
---@param mappings table The key mappings to set.
function Utils.set_keymaps(mappings)
	for k, v in pairs(mappings) do
		local key = k
		if #k > 1 then
			key = {}
			for i = 1, #k do
				table.insert(key, k:sub(i, i))
			end
		end

		for _, m in ipairs(v) do
			vim.keymap.set(key, unpack(m))
		end
	end
end

return Utils
