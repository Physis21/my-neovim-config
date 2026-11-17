-- Colorscheme selection, kept out of git so switching themes leaves the config clean.
-- Priority: $NVIM_COLORSCHEME, then the first line of <config>/.colorscheme, then the default.
local default = "catppuccin"

local name = vim.env.NVIM_COLORSCHEME
if not name or name == "" then
  local file = vim.fn.stdpath("config") .. "/.colorscheme"
  if vim.fn.filereadable(file) == 1 then
    name = vim.trim(vim.fn.readfile(file, "", 1)[1] or "")
  end
end
if not name or name == "" then
  name = default
end

if not pcall(vim.cmd.colorscheme, name) then
  vim.notify("Colorscheme '" .. name .. "' not found, using " .. default, vim.log.levels.WARN)
  vim.cmd.colorscheme(default)
end
