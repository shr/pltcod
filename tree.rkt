#lang racket

(require ffi/unsafe
         "loader.rkt")
(provide (all-defined-out))

(define-cstruct _tree
  ((next _tree-pointer)
   (father _tree-pointer)
   (sons _tree-pointer)))

(deftcod tree-new : -> _tree-pointer)
(deftcod tree-add-son : _tree-pointer _tree-pointer -> _void)
