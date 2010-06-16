#lang racket

(require ffi/unsafe
         "loader.rkt")
(provide (all-defined-out))

(define _map (_cpointer/null "tcod-map"))

(define _fov-algorithm
  (_enum
   '(fov-basic
     fov-diamond
     fov-shadow
     fov-permissive-0
     fov-permissive-1
     fov-permissive-2
     fov-permissive-3
     fov-permissive-4
     fov-permissive-5
     fov-permissive-6
     fov-permissive-7
     fov-permissive-8
     fov-restrictive
     fov-algorithm-number)))

(deftcod map-new : _int _int -> _map)
(deftcod map-clear : _map -> _void)
(deftcod map-copy : _map _map -> _void)
; void TCOD_map_set_properties(TCOD_map_t map, int x, int y, bool is_transparent, bool is_walkable);
(deftcod map-set-properties : _map _int _int _bool _bool -> _void)
(deftcod map-delete : _map -> _void)

; void TCOD_map_compute_fov(TCOD_map_t map, int player_x, int player_y, int max_radius, bool light_walls, TCOD_fov_algorithm_t algo);
(deftcod map-compute-fov : _map _int _int _int _bool _fov-algorithm -> _void)
(deftcod map-is-in-fov? : _map _int _int -> _bool)
(deftcod map-set-in-fov : _map _int _int _bool -> _void)

(deftcod map-is-transparent? : _map _int _int -> _bool)
(deftcod map-is-walkable? : _map _int _int -> _bool)
(deftcod map-get-width : _map -> _int)
(deftcod map-get-height : _map -> _int)
(deftcod map-get-nb-cells : _map -> _int)
