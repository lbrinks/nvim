; Custom markdown injections - adds guard conditions to prevent treesitter bug
; This overrides the default queries/markdown/injections.scm

; Fenced code blocks - inject language parser
(fenced_code_block
  (info_string
    (language) @injection.language)
  (code_fence_content) @injection.content)

; HTML blocks
((html_block) @injection.content
  (#set! injection.language "html")
  (#set! injection.combined)
  (#set! injection.include-children))

; YAML frontmatter
((minus_metadata) @injection.content
  (#set! injection.language "yaml")
  (#offset! @injection.content 1 0 -1 0)
  (#set! injection.include-children))

; TOML frontmatter
((plus_metadata) @injection.content
  (#set! injection.language "toml")
  (#offset! @injection.content 1 0 -1 0)
  (#set! injection.include-children))

; Keep markdown_inline injections for inline formatting
; But only inject into inline nodes (not pipe_table_cell which causes issues)
((inline) @injection.content
  (#set! injection.language "markdown_inline"))
