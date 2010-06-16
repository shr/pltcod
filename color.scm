#lang scheme

(require rnrs/arithmetic/bitwise-6
         scheme/foreign
         "loader.scm")
(provide (all-defined-out))

(unsafe!)

(define-cstruct _color
  ((r _uint8)
   (g _uint8)
   (b _uint8)))

(define (integer->color i)
  (make-color (bitwise-arithmetic-shift-right (bitwise-and i #xff0000) 16)
              (bitwise-arithmetic-shift-right (bitwise-and i #xff00) 8)
              (bitwise-and i #xff)))

(define (color->integer c)
  (bitwise-ior (bitwise-arithmetic-shift-left (color-r c) 16)
               (bitwise-arithmetic-shift-left (color-g c) 8)
               (color-b c)))

(define-syntax define-colors
  (syntax-rules ()
    [(_ (name r g b) ...)
     (begin
       (define name (make-color r g b))
       ...)]))

(define-colors
  (black 0 0 0)
  (darker-grey 31 31 31)
  (dark-grey 63 63 63)
  (grey 128 128 128)
  (light-grey 191 191 191)
  (white 255 255 255))

(define darker-gray darker-grey)
(define dark-gray dark-grey)
(define gray grey)
(define light-gray light-grey)

(define-colors
  (red 255 0 0)
  (orange 255 127 0)
  (yellow 255 255 0)
  (chartreuse 127 255 0)
  (green 0 255 0)
  (sea 0 255 127)
  (cyan 0 255 255)
  (sky 0 127 255)
  (blue 0 0 255)
  (violet 127 0 255)
  (magenta 255 0 255)
  (pink 255 0 127))

(define-colors
  (dark-red 127 0 0)
  (dark-orange 127 63 0)
  (dark-yellow 127 127 0)
  (dark-chartreuse 63 127 0)
  (dark-green 0 127 0)
  (dark-sea 0 127 63)
  (dark-cyan 0 127 127)
  (dark-sky 0 63 127)
  (dark-blue 0 0 127)
  (dark-violet 63 0 127)
  (dark-magenta 127 0 127)
  (dark-pink 127 0 63))

(define-colors
  (darker-red 63 0 0)
  (darker-orange 63 31 0)
  (darker-yellow 63 63 0)
  (darker-green 0 63 0)
  (darker-sea 0 63 31)
  (darker-cyan 0 63 63)
  (darker-sky 0 31 63)
  (darker-blue 0 0 63)
  (darker-violet 31 0 63)
  (darker-magenta 63 0 63)
  (darker-pink 63 0 31))

(define-colors
  (light-red 255 127 127)
  (light-orange 255 191 127)
  (light-yellow 255 255 127)
  (light-chartreuse 191 255 127)
  (light-green 127 255 127)
  (light-sea 127 255 191)
  (light-cyan 127 255 255)
  (light-sky 127 191 255)
  (light-blue 127 127 255)
  (light-violet 191 127 255)
  (light-magenta 255 127 255)
  (light-pink 255 127 191))

(define-colors
  (desaturated-red 127 63 63)
  (desaturated-orange 127 95 63)
  (desaturated-yellow 127 127 63)
  (desaturated-chartreuse 95 127 63)
  (desaturated-green 63 127 63)
  (desaturated-sea 63 127 95)
  (desaturated-cyan 63 127 127)
  (desaturated-sky 63 95 127)
  (desaturated-blue 63 63 127)
  (desaturated-violet 95 63 127)
  (desaturated-magenta 127 63 127)
  (desaturated-pink 127 63 95))

(define-colors
  (silver 203 203 203)
  (gold 255 255 102))

; constructors
(deftcod color-RGB : _uint8 _uint8 _uint8 -> _color)
(deftcod color-HSV : _float _float _float -> _color)

; basic operations
(deftcod color-equals? : _color _color -> _bool)
(deftcod color-add : _color _color -> _color)
(deftcod color-subtract : _color _color -> _color)
(deftcod color-multiply : _color _color -> _color)
(deftcod color-multiply-scalar : _color _float -> _color)
(deftcod color-lerp : _color _color _float -> _color)

; HSV transformations
(deftcod color-get-hue : _color -> _float)
(deftcod color-get-saturation : _color -> _float)
(deftcod color-get-value : _color -> _float)

(define (hsv->color h s v)
  (deftcod color-set-HSV : (c : (_ptr o _color)) _float _float _float -> _void -> c)
  (let ([c (color-set-HSV (exact->inexact h) (exact->inexact s) (exact->inexact v))])
    c))
(define (color->hsv c)
  (deftcod color-get-HSV :
    _color
    (h : (_ptr o _float))
    (s : (_ptr o _float))
    (v : (_ptr o _float)) -> _void -> (values h s v))
  (color-get-HSV c))
; TODO: TCOD_color_gen_map
