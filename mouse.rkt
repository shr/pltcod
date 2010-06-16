#lang racket

(require ffi/unsafe
         "loader.rkt")

(define-cstruct _mouse
  ((x _int)
   (y _int)
   (dx _int)
   (dy _int)
   (dcx _int)
   (dcy _int)
   (lbutton _bool)
   (rbutton _bool)
   (lbutton-pressed? _bool)
   (rbutton-pressed? _bool)
   (mbutton-pressed? _bool)
   (wheel-up? _bool)
   (wheel-down? _bool)))

(deftcod mouse-get-status : -> _mouse)
(deftcod mouse-show-cursor : _bool -> _void)
(deftcod mouse-is-cursor-visible? : -> _bool)
(deftcod mouse-move : _int _int -> _void)
