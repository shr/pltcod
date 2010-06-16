#lang scheme

(require scheme/foreign
         "loader.scm")
(provide (all-defined-out))

(unsafe!)

(define-cstruct _tree
  ((next _tree-pointer)
   (father _tree-pointer)
   (sons _tree-pointer)))

(deftcod tree-new : -> _tree-pointer)
(deftcod tree-add-son : _tree-pointer _tree-pointer -> _void)