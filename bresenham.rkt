#lang racket

(require ffi/unsafe
         "loader.rkt")
(provide (all-defined-out))

(define _line_listener (_fun _int _int -> _bool))

;;; the single-threaded version
; void TCOD_line_init(int xFrom, int yFrom, int xTo, int yTo);
(deftcod line-init : _int _int _int _int -> _void)
; bool TCOD_line_step(int *xCur, int *yCur)
(deftcod line-step : (x : (_ptr o _int)) (y : (_ptr o _int)) -> (r : _bool) ->
  (if r (void) (values x y)))
(deftcod line : _int _int _int _int _line_listener -> _bool)

(define-cstruct _bresenham-data
  ((stepx _int)
   (stepy _int)
   (e _int)
   (deltax _int)
   (deltay _int)
   (origx _int)
   (origy _int)
   (destx _int)
   (desty _int)))

(deftcod line-init-mt : _int _int _int _int (r : (_ptr o _bresenham-data)) -> _void ->
  r)
(deftcod line-step-mt : (x : (_ptr o _int)) (y : (_ptr o _int)) (d : (_ptr io _bresenham-data))
  -> (r : _bool) -> (if r (void) (values x y)))
(deftcod line-mt : _int _int _int _int _line_listener (r : (_ptr o _bresenham-data)) -> _bool -> r)

;;; TODO: wrap this in a make-do-sequence
     
