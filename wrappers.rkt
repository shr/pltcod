#lang racket

(require ffi/unsafe
         "loader.rkt")
(provide (all-defined-out))

; color wrappers
(define _colornum _uint)

(deftcod color-equals-wrapper : _colornum _colornum -> _bool)
(deftcod color-add-wrapper : _colornum _colornum -> _colornum)
