return {
  -- add gdscript to lspconfig
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        gdscript = {},
      },
    },
  },
}
