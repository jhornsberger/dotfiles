; Tree-sitter query to add tac support to the aerial.nvim Neovim plugin
; [https://github.com/stevearc/aerial.nvim].
;
; The query makes use of the Namespace and Field symbols kinds. These are
; filtered in the default aerial.nvim configuration, but can be enabled by
; adding them to the filter_kind option. See :h aerial-options.

(namespace_def
  name: (ident) @name
  (#set! "kind" "Namespace")
  ) @symbol

(enum_def
  name: (ident) @name
  (#set! "kind" "Enum")
  ) @symbol

(type_def
  name: (ident) @name
  (#set! "kind" "Class")
  ) @symbol

(func_def
  (ident) @name
  (#set! "kind" "Function")
  ) @symbol

(attr_def
  name: (ident) @name
  (#set! "kind" "Field")
  ) @symbol
