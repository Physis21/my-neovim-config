# Physis21 Neovim config

- This config has been created following [this youtube video](https://youtu.be/KYDG3AHgYEs?si=XzmA9sXohIXH1aRv), which itself is heavily influenced by kickstart.

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
