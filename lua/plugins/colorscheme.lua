-- All colorschemes load at startup so `:colorscheme <Tab>` lists them.
-- Loading only runs setup(); the active one is applied in core/colorscheme.lua.
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    opts = {
      flavour = "mocha",
      -- base is the main background.
      color_overrides = { mocha = { base = "#000000" } },
    },
  },
  { "scottmckendry/cyberdream.nvim", lazy = false },
  { "p00f/alabaster.nvim", lazy = false },
  { "folke/tokyonight.nvim", lazy = false, opts = {} },
  {
    "navarasu/onedark.nvim",
    lazy = false,
    config = function()
      require("onedark").setup({
        style = "deep",
        -- bg0 is the main background; "black" is a darker accent color, not the background.
        colors = {
          bg0 = "#000000",
        },
        -- transparent = "true",
      })
      require("onedark").load()
    end,
  },
}
