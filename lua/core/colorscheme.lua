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

-- Comments carry important information, so every colorscheme shows them in high-contrast red.
-- Only the foreground changes; the theme's other attributes (italic, ...) are kept.
local red_comments = true

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    if not red_comments then
      return
    end
    for _, group in ipairs({ "Comment", "@comment", "@lsp.type.comment" }) do
      -- nvim_get_hl's result is valid input for nvim_set_hl, which also accepts "#rrggbb" strings.
      local hl = vim.api.nvim_get_hl(0, { name = group, link = false }) --[[@as vim.api.keyset.highlight]]
      hl.fg = "#ff4040"
      vim.api.nvim_set_hl(0, group, hl)
    end
  end,
})

-- Reapplying the colorscheme restores the theme's own comment colors when turning off.
vim.api.nvim_create_user_command("RedCommentsToggle", function()
  red_comments = not red_comments
  vim.cmd.colorscheme(vim.g.colors_name)
end, { desc = "Toggle high-contrast red comments" })

if not pcall(vim.cmd.colorscheme, name) then
  vim.notify("Colorscheme '" .. name .. "' not found, using " .. default, vim.log.levels.WARN)
  vim.cmd.colorscheme(default)
end
