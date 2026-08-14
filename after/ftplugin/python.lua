-- Disable the built-in indent expression set by indent/python.vim
vim.bo.indentexpr = ""
-- Python options
-- Disable smartindent, which causes double-indentation on continuation lines
vim.bo.smartindent = false
vim.o.shiftwidth = 4
-- Use the default indentexpr behavior without stacking
vim.bo.cindent = false
-- Ensure the Python indent plugin doesn't double-apply
vim.g.pyindent_open_paren = "shiftwidth()"
vim.g.pyindent_continue = "shiftwidth()"
vim.g.pyindent_nested_paren = "shiftwidth()"
-- vim.opt_local.indentexpr = ""
-- vim.opt_local.smartindent = false
-- vim.opt_local.autoindent = true
-- vim.opt_local.shiftwidth = 4
-- vim.opt_local.tabstop = 4
-- vim.opt_local.expandtab = true
