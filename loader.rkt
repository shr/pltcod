#lang racket

(require ffi/unsafe)
(provide libtcod deftcod)

(define libtcod
  (ffi-lib (case (system-type 'os)
             ['windows "libtcod-mingw.dll"]
             [else "libtcod.so"])))

(define-syntax deftcod
  (syntax-rules (:)
    [(_ name : type ...)
     (define name (get-ffi-obj
                   (regexp-replaces 'name '((#rx"-" "_")
                                            (#rx"[+*?!]" "")
                                            (#rx"^" "TCOD_")))
                   libtcod (_fun type ...)))]))

