local vim = vim

vim.api.nvim_create_user_command("TextMode", "set wrap | set spell | set spelllang=pt,en", {})
