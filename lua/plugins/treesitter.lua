local is_windows = require("core.os").is_windows

return { -- Highlight, edit, and navigate code
  "nvim-treesitter/nvim-treesitter",
  -- build = is_windows and ":TSUpdate" or nil,
  -- branch = is_windows and "master" or nil, -- master branch ensures better compatibility on Windows
  -- main = is_windows and "nvim-treesitter.configs" or nil, -- Sets main module to use for opts
  build = ":TSUpdate",
  opts = {
    highlight = { enable = true },
    indent = {
      enable = true,
      -- disable = { "python" },
    },
  },
  config = function()
    if is_windows then
      require("nvim-treesitter.install").compilers = { "clang", "gcc" } -- clang works on Windows, gcc doesn't
    end
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
