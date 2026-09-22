; extends

; Inline LaTeX/KaTeX math, e.g. `$x^2$`.
; Neither tree-sitter-markdown nor nvim-treesitter ship a highlight query for
; this node, so it goes uncolored by default even though the parser already
; exposes it as `latex_block` (markdown_inline aliases the inline latex span
; to this name, same as the block-level `$$...$$` node).
(latex_block) @markup.math
((latex_span_delimiter) @punctuation.special)
