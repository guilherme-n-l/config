local typst = require("typst-preview")

typst.setup({
	dependencies_bin = {
		["tinymist"] = "tinymist",
		["websocat"] = "websocat",
	},
})
