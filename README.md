# Physis21 Neovim config

- This config has been created following [this youtube video](https://youtu.be/KYDG3AHgYEs?si=XzmA9sXohIXH1aRv), which itself is heavily influenced by kickstart.
- This single config works on both Linux and Windows: `lua/core/os.lua` exposes `is_windows`, and a handful of files branch on it to apply OS-specific settings (see below). There is no separate Windows branch anymore.

**IMPORTANT**: this config is only compatible with **Neovim v0.12**. There are breaking changes from v0.11 to v0.12, e.g the LSP configurations.

## Requirements

- On windows, clang and gcc must be installed with MSYS2

  &rarr; [link to MSYS2 installation of clang](https://www.mingw-w64.org/getting-started/msys2-llvm/)

- **none-ls** requires npm and node.js installed.

  &rarr; [link to the installer](https://kinsta.com/blog/how-to-install-node-js/#1-download-the-windows-installer)

- Install `treesitter-cli` via cargo or node.

## OS-specific behavior

- `lua/plugins/treesitter.lua`: on Windows, uses the `master` branch (with `build = ":TSUpdate"` and `main = "nvim-treesitter.configs"`) and forces the `clang` compiler, since `gcc` doesn't work there. On Linux, none of this is set and the default branch/compiler are used.
- `lua/plugins/nvim-dap.lua`: the Python virtual environment executable lives at `.venv/Scripts/python` on Windows vs `.venv/bin/python` on Linux; `require("core.os").is_windows` picks the right one.
- `lua/plugins/neotree.lua`: `image.nvim` (optional image preview support) is only added as a dependency on Linux.
  It needs extra native deps that are hard to set up on Windows.
- `lua/core/options.lua`: `vim.o.shell` is set to `powershell.exe` on Windows only.

## Info on some dependencies

### Treesitter

Treesitter is a parser used for syntactic highlighting. On recent neovim versions, it is included in neovim.
A grammar is specified with a `grammar.js` file, with which

```bash
$ treesitter generate -o outdir
```

generates a `parser.c` file with its header file and other related files (e.g `grammar.json`).
Treesitter is written in C, but has interfaces for many languages.

> Its [Latex parser](https://github.com/latex-lsp/tree-sitter-latex)
> is hard to build against in rust, as it doesn't generate parser.c automatically.

`parser.c` contains notable functions:

- `ts_parser_set_language` to set a Language to parse,
- and `ts_parser_parse_string` to then generate an AST and return it

> In C, `ts_tree_delete` and `ts_parser_delete` need to be called afterwards (arena alloc I guess),
> but not in Rust (automatic free on scope end) .

## Some handy commands & their context

### Code analysis

- Remove floating diagnostic texts if they take too much space

  ```vim
  :lua vim.diagnostic.enable(false)
  ```

- Rename variable:
  Hover over variable, then type

  ```vim
  :lua vim.lsp.buf.rename()
  ```

- Treesitter querying:
  - `:Inspect` to show the highlight groups under the cursor
  - `:InspectTree` to show the parsed syntax tree
  - `:EditQuery` to open the Live Query Editor
    (uses a [lisp-like language](https://tree-sitter.github.io/tree-sitter/3-syntax-highlighting.html))
    - `o` in `:InspectTree` does the same thing.

### Git

- Use git fugitive and [gitsigns](https://github.com/lewis6991/gitsigns.nvim) commands!
  [Example YT tutorial](https://www.youtube.com/watch?v=IyBAuDPzdFY)
  - `:Git` is similar to `git status`.
    - `git add` files with `-` (you can visual select multiple files and add them)
    - `=` lets you see the commit changes, `<Enter>` to open the file
  - View diffs with `Gdiff` or `Gvdiff`:
    - `Gvdiff <branch-name` allows comparisons with branches
    - I mapped `[c` and `]c` to go to the previous and next change
      (from `gitsigns`'s default config)
  - `:Gwrite` git adds the file
  - `:Gread` reads the last stages, which is equivalent to `git reset`
  - `:Git log`, self explanatory (change a hsplit to a vsplit with `<C-w>H`)
    - `<Enter>` lets you see the specific changes of that commit
  - `:Git blame`: interactive blame buffer
  - `:Git commit` basically the same as `git commit`
  - **Telescope** also has git commands!
    - `:Telescope git_status` to fuzzy search git edited files
    - `:Telescope git_commits` to fuzzy search git logs
    - `:Telescope git_branches` to fuzzy search git branches

## Misc info

- The `./plugin/` folder simply executes the code in its lua files on nvim startup, without needing to `require` them in `./init.lua`.
  This is usually left empty, or at least very minimal.
- `o` and `x` modes refer to `Operator-pending` and `mapmode-x`. Check them out with neovim's help.
- I added the LSP `mdx_analyzer` for MDX files ([for docusaurus](https://docusaurus.io/)), but they don't seem well-accepted.
  By default, neovim does'nt recognize the .mdx filetype and neither does treesitter, so I use the markdown grammar for MDX files.
