-- All colorschemes load at startup so `:colorscheme <Tab>` lists them.
-- Loading only runs setup(); the active one is applied in core/colorscheme.lua.
return {
  { "catppuccin/nvim", name = "catppuccin", lazy = false, opts = { flavour = "mocha" } },
  { "scottmckendry/cyberdream.nvim", lazy = false },
  { "p00f/alabaster.nvim", lazy = false },
  { "folke/tokyonight.nvim", lazy = false, opts = {} },
  { "navarasu/onedark.nvim", lazy = false, opts = { style = "darker" } },
}
