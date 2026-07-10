---@param s string
local function fail(s, ...)
	ya.notify({ title = "drag", content = string.format(s, ...), timeout = 3, level = "error" })
end

---@return string[]
local selected_files = ya.sync(function()
	local tab, paths = cx.active, {}
	for _, u in pairs(tab.selected) do
		paths[#paths + 1] = tostring(u)
	end
	if #paths == 0 and tab.current.hovered then
		paths[1] = tostring(tab.current.hovered.url)
	end
	return paths
end)

---@return string
local function get_os()
	return (select(1, Command("uname"):stdout(Command.PIPED):output()).stdout or ""):lower()
end

return {
	entry = function()
		local files = selected_files()

		if #files == 0 then
			return
		end

		local cmd

		if get_os():match("^darwin") then
			-- ripdrag is Linux-only; on macOS copy the selection into a fresh
			-- temp dir and reveal it in Finder so it can be dragged out.
			local quoted = {}
			for _, file in ipairs(files) do
				quoted[#quoted + 1] = "'" .. file:gsub("'", "'\\''") .. "'"
			end

			local file_str = table.concat(quoted, " ")
			local bash_cmd = string.format(
				[[
set -eu
target="$(mktemp -d "${TMPDIR:-/tmp}/yazi-drag.XXXXXX")"
# Prefer an APFS clone (instant, copy-on-write, no extra space); fall back to
# a plain copy for non-APFS or cross-volume selections.
cp -Rc %s "$target"/ 2>/dev/null || cp -R %s "$target"/
open "$target"
]],
				file_str,
				file_str
			)
			cmd = Command("bash"):arg({ "-c", bash_cmd })
		else
			cmd = Command("ripdrag"):arg({ "-a", "-x" }):arg(files)
		end

		local child, err = cmd:spawn()
		if not child then
			fail("Spawn failed with error code %s.", err)
			return
		end
		local output
		output, err = child:wait_with_output()
		if not output then
			fail("Cannot read output, error code %s", err)
		elseif not output.status.success and output.status.code ~= 131 then
			fail("Drag helper exited with error code %s", output.status.code)
		end
	end,
}
