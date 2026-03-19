-- Python options
-- Disable smartindent, which causes double-indentation on continuation lines
vim.bo.smartindent = false
-- Use the default indentexpr behavior without stacking
vim.bo.cindent = false
-- Ensure the Python indent plugin doesn't double-apply
vim.g.pyindent_open_paren = 'shiftwidth()'
vim.g.pyindent_continue = 'shiftwidth()'
vim.g.pyindent_nested_paren = 'shiftwidth()'
