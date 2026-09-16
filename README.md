# Physis21 Neovim config

- This config has been created following [this youtube video](https://youtu.be/KYDG3AHgYEs?si=XzmA9sXohIXH1aRv), which itself is heavily influenced by kickstart.
- On windows, I need to remove:
  - image.nvim requirement in neotree

## Requirements

- On windows, clang and gcc must be installed with MSYS2
  &rarr; [link to MSYS2 installation of clang](https://www.mingw-w64.org/getting-started/msys2-llvm/)
- **none-ls** requires npm and node.js installed.
  &rarr; [link to the installer](https://kinsta.com/blog/how-to-install-node-js/#1-download-the-windows-installer)

## Modification with respect to Linux installation

- For treesitter to work, the clang compiler works while gcc can not work on windows. Therefore, I have added the config in `lua/plugins/treesitter.lua`:

  ```lua
  config = function()
      require("nvim-treesitter.install").compilers = {"clang", "gcc"}
    end,
  ```

  - Moreover, using `branch = "master"` ensures better compatibility for windows.

- In Windows python virtual environments, the python executable is located in `.venv\Scripts\python` instead of the usual `.venv\bin\python` in Linux. Therefore, I modified the config in `nvim-dap.lua`

## Some handy commands

- Remove floating diagnostic texts if they take too much space

```vim
:lua vim.diagnostic.enable(false)
```

- Rename variable:
  Hover over variable, then type
  ```vim
  :lua vim.lsp.buf.rename()
  ```
