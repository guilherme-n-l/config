local new = vim.api.nvim_create_user_command
new("TextMode", "set wrap | set spell | set spelllang=pt,en", {})
