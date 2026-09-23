return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPost", "BufWritePost", "InsertLeave" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      make = { "checkmake" },
    }

    local augroup = vim.api.nvim_create_augroup("Linting", {})
    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
      group = augroup,
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
