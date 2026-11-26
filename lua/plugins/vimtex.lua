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
    -- continuous = 0: :VimtexCompile builds once instead of running latexmk -pvc in the background.
    -- VimTeX merges this table into its defaults, so unset keys keep their default values.
    -- aux_dir holds the intermediate files; an empty out_dir writes the PDF next to the .tex file.
    vim.g.vimtex_compiler_latexmk = { aux_dir = ".latexmk", out_dir = "", continuous = 0 }
  end,
}
