dofile(vim.fn.stdpath("config") .. "/utils.lua")
Load_modules()
Load_lazy()
Do_after({ Load_lsps, Load_colorscheme })
