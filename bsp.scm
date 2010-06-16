#lang scheme

(require scheme/foreign
         "loader.scm"
         "mersenne.scm"
         "tree.scm")
(unsafe!)

(define-cstruct _bsp
  ((tree _tree)
   (x _int)
   (y _int)
   (w _int)
   (h _int)
   (position _int)
   (level _uint8)
   (horizontal _bool)))

(define _bsp-ptr (_or-null _bsp-pointer))
(define _bsp-callback (_fun _bsp-ptr _pointer -> _bool))

(deftcod bsp-new : -> _bsp-pointer)
(deftcod bsp-new-with-size : _int _int _int _int -> _bsp-pointer)
(deftcod bsp-delete : _bsp-ptr -> _void)

(deftcod bsp-left : _bsp-ptr -> _bsp-ptr)
(deftcod bsp-right : _bsp-ptr -> _bsp-ptr)
(deftcod bsp-father : _bsp-ptr -> _bsp-ptr)

(deftcod bsp-is-leaf? : _bsp-ptr -> _bool)

(deftcod bsp-traverse-pre-order : _bsp-ptr _bsp-callback _pointer -> _bool)
(deftcod bsp-traverse-in-order : _bsp-ptr _bsp-callback _pointer -> _bool)
(deftcod bsp-traverse-post-order : _bsp-ptr _bsp-callback _pointer -> _bool)
(deftcod bsp-traverse-level-order : _bsp-ptr _bsp-callback _pointer -> _bool)
(deftcod bsp-traverse-inverted-level-order : _bsp-ptr _bsp-callback _pointer -> _bool)

(deftcod bsp-contains? : _bsp-ptr _int _int -> _bool)
(deftcod bsp-resize : _bsp-ptr _int _int _int _int -> _void)
(deftcod bsp-split-once : _bsp-ptr _bool _int -> _void)
; void TCOD_bsp_split_recursive(TCOD_bsp_t *node, TCOD_random_t randomizer, int nb,  int minHSize, int minVSize, float maxHRatio, float maxVRatio);
(deftcod bsp-split-recursive : _bsp-ptr _random _int _int _int _float _float -> _void)
(deftcod bsp-remove-sons : _bsp-ptr -> _void)