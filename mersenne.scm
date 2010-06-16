#lang scheme

(require scheme/foreign
         "loader.scm")
(provide (all-defined-out))

(unsafe!)

(define _random_algo
  (_enum
   '(rng-mersenne-twister
     rng-cmwc)))

(define _random (_cpointer/null "tcod-random"))

(deftcod random-get-instance : -> _random)
(deftcod random-new : _random_algo -> _random)
(deftcod random-save : _random -> _random)
(deftcod random-restore : _random _random -> _random)
(deftcod random-new-from-seed : _uint32 -> _random)
(deftcod random-get-int : _random _int _int -> _int)
(deftcod random-get-float : _random _float _float -> _float)
(deftcod random-delete : _random -> _void)
(deftcod random-get-gaussian-float : _random _float _float -> _float)
(deftcod random-get-gaussian-int : _random _int _int -> _int)