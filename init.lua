require("core.options") -- Load general options
require("core.keymaps") -- Load general keymaps

-- Set up the Lazy plugin manager.
-- The vim.fn wrapper is the only way to access vimscript functions from lua.
-- stdpath("data") persistently stores the data between neovim sessions.
-- '..' is the concatenation operator
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable", -- latest stable relase
    lazyrepo,
    lazypath, -- Lazy is installed into the lazypath
  })
  if vim.v.shell_error ~= 0 then
    error("Error cloning lazy.nvim:\n" .. out)
  end
end
-- rtp = runtime path
-- This is where neovim looks when it has a question that it can't answer itself.
-- 'prepend' means nvim will look at lazypath first in the runtime path.
vim.opt.rtp:prepend(lazypath)

-- Define plugins

require("lazy").setup({
  require("plugins.neotree"),
  require("plugins.colortheme"),
  require("plugins.bufferline"),
  require("plugins.lualine"),
  require("plugins.treesitter"),
  require("plugins.telescope"),
  require("plugins.lsp"),
  require("plugins.autocompletion"),
  require("plugins.none-ls"),
  require("plugins.gitsigns"),
  require("plugins.alpha"),
  require("plugins.indent-blankline"),
  require("plugins.misc"),
  require("plugins.comment"),
  require("plugins.nvim-dap"),
  require("plugins.cmake-tools"),
  require("plugins.autoformat"),
  require("plugins.surround"),
  -- require("plugins.vimtex"), -- Does not work with nvim0.11 at the moment.
})
