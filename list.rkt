#lang racket

(require ffi/unsafe
         "loader.rkt")
(provide (all-defined-out))

(define _lst (_cpointer/null "libtcod-list"))

(deftcod list-new : -> _lst)
(deftcod list-allocate : _int -> _lst)
(deftcod list-duplicate : _lst -> _lst)
(deftcod list-delete : _lst -> _void)

;;; this is a skeleton implementation
