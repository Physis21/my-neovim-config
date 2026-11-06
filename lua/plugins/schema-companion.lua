return {
  "cenk1cenk2/schema-companion.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {},
  config = function(_, opts)
    local sc = require("schema-companion")
    sc.setup(opts)
    vim.api.nvim_create_user_command("SCSelectSchema", sc.select_schema, {})
    vim.api.nvim_create_user_command("SCGetCurrentSchemas", sc.get_current_schemas, {})
  end,
}
