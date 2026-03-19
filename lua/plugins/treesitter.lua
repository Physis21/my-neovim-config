return { -- Highlight, edit, and navigate code
  "nvim-treesitter/nvim-treesitter",
  config = function()
    local filetypes = {
      "bash",
      "c",
      "diff",
      "html",
      "javascript",
      "css",
      "lua",
      "luadoc",
      "markdown",
      "markdown_inline",
      "query",
      "sql",
      "vim",
      "vimdoc",
      "python",
      "cpp",
      "rust",
    }
    require("nvim-treesitter").install(filetypes)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = filetypes,
      callback = function()
        vim.treesitter.start()
      end,
    })
  end,
}
