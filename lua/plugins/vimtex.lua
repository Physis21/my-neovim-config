-- to configure compile flags, use .latexmkrc at root of project folders.
-- This will get picked up by latexmk when called.
-- this plugins creates commands, named VimTex*. They appear as options when editing a TeX file.

return {
  "lervag/vimtex",
  -- already lazy loaded due to being a filetype plugin and using autoload.
  -- lazy loading breaks inverse-search mechanism :VimTexInverseSearch
  lazy = false,
  init = function()
    vim.g.vimtex_view_enabled = 0 -- the PDF is viewed separately (e.g outside WSL)
    vim.g.vimtex_compiler_latexmk = { out_dir = "build" } -- keep VimTeX's default options
  end,
}
