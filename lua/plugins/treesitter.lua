return { -- Highlight, edit, and navigate code
  "nvim-treesitter/nvim-treesitter",
  opts = {
    highlight = { enable = true },
    indent = {
      enable = true,
      -- disable = { "python" },
    },
  },
  config = function()
    local filetypes = {
      "java",
      "bash",
      "c",
      "c_sharp",
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
