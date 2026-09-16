# Physis21 Neovim config

- This config has been created following [this youtube video](https://youtu.be/KYDG3AHgYEs?si=XzmA9sXohIXH1aRv), which itself is heavily influenced by kickstart.
- This single config works on both Linux and Windows: `lua/core/os.lua` exposes `is_windows`, and a handful of files branch on it to apply OS-specific settings (see below). There is no separate Windows branch anymore.

**IMPORTANT**: this config is only compatible with **Neovim v0.12**. There are breaking changes from v0.11 to v0.12, e.g the LSP configurations.

## Requirements

- On windows, clang and gcc must be installed with MSYS2
  &rarr; [link to MSYS2 installation of clang](https://www.mingw-w64.org/getting-started/msys2-llvm/)
- **none-ls** requires npm and node.js installed.
  &rarr; [link to the installer](https://kinsta.com/blog/how-to-install-node-js/#1-download-the-windows-installer)

## OS-specific behavior

- `lua/plugins/treesitter.lua`: on Windows, uses the `master` branch (with `build = ":TSUpdate"` and `main = "nvim-treesitter.configs"`) and forces the `clang` compiler, since `gcc` doesn't work there. On Linux, none of this is set and the default branch/compiler are used.
- `lua/plugins/nvim-dap.lua`: the Python virtual environment executable lives at `.venv/Scripts/python` on Windows vs `.venv/bin/python` on Linux; `require("core.os").is_windows` picks the right one.
- `lua/plugins/neotree.lua`: `image.nvim` (optional image preview support) is only added as a dependency on Linux.
  It needs extra native deps that are hard to set up on Windows.
- `lua/core/options.lua`: `vim.o.shell` is set to `powershell.exe` on Windows only.

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
