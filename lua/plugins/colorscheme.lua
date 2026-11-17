-- All colorschemes are installed but lazy-loaded: lazy.nvim loads the matching
-- plugin when `:colorscheme <name>` is called. The active one is chosen in core/colorscheme.lua.
-- List installed colorschemes with `:Telescope colorscheme`.
return {
  { "catppuccin/nvim", name = "catppuccin", lazy = true, opts = { flavour = "mocha" } },
  { "scottmckendry/cyberdream.nvim", lazy = true },
  { "p00f/alabaster.nvim", lazy = true },
}
