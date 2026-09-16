return { -- Highlight, edit, and navigate code
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  branch = "master", -- ensures better compatibility on Windows
  main = "nvim-treesitter.configs", -- Sets main module to use for opts
  opts = {
    highlight = { enable = true },
    indent = {
      enable = true,
      -- disable = { "python" },
    },
  },
  config = function()
    require("nvim-treesitter.install").compilers = { "clang", "gcc" } -- clang works on Windows, gcc doesn't
    local filetypes = {
      "asm",
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
