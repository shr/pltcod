#lang racket

(require ffi/unsafe
         "loader.rkt"
         "mersenne.rkt"
         "noise.rkt")
(provide (all-defined-out))

(define-cstruct _heightmap
  ((w _int)
   (h _int)
   (values (_cpointer _float))))

(deftcod heightmap-new : _int _int -> _heightmap-pointer)
(deftcod heightmap-delete : _heightmap-pointer -> _void)
(deftcod heightmap-get-value : _heightmap-pointer _int _int -> _float)
(deftcod heightmap-get-interpolated-value : _heightmap-pointer _float _float -> _float)
(deftcod heightmap-set-value : _heightmap-pointer _int _int _float -> _void)
(deftcod heightmap-get-slope : _heightmap-pointer _int _int -> _float)
; void TCOD_heightmap_get_normal(const TCOD_heightmap_t *hm, float x, float y, float n[3], float waterLevel);
(deftcod heightmap-get-normal : 
  _heightmap-pointer _float _float (n : (_vector o _float 3)) _float -> _void ->
  n)
(deftcod heightmap-count-cells : _heightmap-pointer _float _float -> _int)
(deftcod heightmap-has-land-on-border : _heightmap-pointer _float -> _bool)
(deftcod heightmap-get-minmax :
  _heightmap-pointer (x : (_ptr o _float)) (y : (_ptr o _float)) -> _void -> (cons x y))
(deftcod heightmap-copy : _heightmap-pointer _heightmap-pointer -> _void)
(deftcod heightmap-add : _heightmap-pointer _float -> _void)
(deftcod heightmap-scale : _heightmap-pointer _float -> _void)
(deftcod heightmap-clamp : _heightmap-pointer _float _float -> _void)
(deftcod heightmap-normalize : _heightmap-pointer _float _float -> _void)
(deftcod heightmap-clear : _heightmap-pointer -> _void)
(deftcod heightmap-lerp-hm :
  _heightmap-pointer _heightmap-pointer _heightmap-pointer _float -> _void)
(deftcod heightmap-add-hm : _heightmap-pointer _heightmap-pointer _heightmap-pointer -> _void)
(deftcod heightmap-multiply-hm :
  _heightmap-pointer _heightmap-pointer _heightmap-pointer -> _void)
(deftcod heightmap-add-hill : _heightmap-pointer _float _float _float -> _void)
(deftcod heightmap-dig-hill : _heightmap-pointer _float _float _float -> _void)
(deftcod heightmap-dig-bezier :
  _heightmap-pointer (_vector i _float) (_vector i _float)
  _float _float _float _float ->
  _void)
(deftcod heightmap-rain-erosion :
  _heightmap-pointer _int _float _float _random -> _void)
;;; all these might be defective
(deftcod heightmap-kernel-transform :
  _heightmap-pointer _int (x : (_ptr o _int)) (y : (_ptr o _int)) (w : (_ptr o _float))
  _float _float -> _void -> (list x y w))
(deftcod heightmap-add-voronoi :
  _heightmap-pointer _int (l : _int) (_vector io _float l) _random -> _void)
; void TCOD_heightmap_add_fbm(TCOD_heightmap_t *hm, TCOD_noise_t noise,float mulx, float muly, float addx, float addy, float octaves, float delta, float scale);
(deftcod heightmap-add-fbm :
  _heightmap-pointer _noise
  _float _float _float _float
  _float _float _float -> _void)
; void TCOD_heightmap_scale_fbm(TCOD_heightmap_t *hm, TCOD_noise_t noise,float mulx, float muly, float addx, float addy, float octaves, float delta, float scale);
(deftcod heightmap-scale-fbm :
  _heightmap-pointer _noise
  _float _float _float _float
  _float _float _float -> _void)
; void TCOD_heightmap_islandify(TCOD_heightmap_t *hm, float seaLevel,TCOD_random_t rnd);
(deftcod heightmap-islandify : _heightmap-pointer _float _random -> _void)
