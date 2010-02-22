#lang scheme

(require scheme/foreign
         "loader.scm"
         "fov.scm")
(unsafe!)

(define _map-path (_cpointer/null "tcod-path"))

;  float (*TCOD_path_func_t)( int xFrom, int yFrom, int xTo, int yTo, void *user_data );
(define _path-function (_fun _int _int _int _int _pointer -> _float))

;  TCOD_path_t TCOD_path_new_using_map(TCOD_map_t map, float diagonalCost);
(deftcod path-new-using-map : _map _float -> _map-path)
(deftcod path-new-using-function : _int _int _path-function _float -> _map-path)

(deftcod path-compute : _map-path _int _int _int _int -> _bool)
(deftcod path-walk : _map-path (x : (_ptr o _int)) (y : (_ptr o _int)) _bool -> (r : _bool) ->
  (values r (cons x y)))
(deftcod path-is-empty? : _map-path -> _bool)
(deftcod path-get : _map-path _int (x : (_ptr o _int)) (y : (_ptr o _int)) -> _void ->
  (cons x y))
(deftcod path-get-origin : _map-path (x : (_ptr o _int)) (y : (_ptr o _int)) -> _void ->
  (cons x y))
(deftcod path-get-destination : _map-path (x : (_ptr o _int)) (y : (_ptr o _int)) -> _void ->
  (cons x y))
(deftcod path-delete : _map-path -> _void)

(define _dijkstra-path (_cpointer/null "tcod-dijkstra"))

(deftcod dijkstra-new : _map _float -> _dijkstra-path)
(deftcod dijkstra-compute : _dijkstra-path _int _int -> _void)
(deftcod dijkstra-get-distance : _dijkstra-path _int _int -> _float)
(deftcod dijkstra-path-set : _dijkstra-path _int _int -> _void)
(deftcod dijkstra-path-walk : _dijkstra-path (x : (_ptr o _int)) (y : (_ptr o _int)) ->
  (r : _bool) -> (values r (cons x y)))
(deftcod dijkstra-delete : _dijkstra-path -> _void)