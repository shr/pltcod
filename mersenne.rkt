#lang racket

(require ffi/unsafe
         "loader.rkt")
(provide (all-defined-out))

(define _random_algo
  (_enum
   '(rng-mersenne-twister
     rng-cmwc)))

(define _distribution
  (_enum
   '(linear gaussian gaussian-range gaussian-inverse gaussian-range-inverse)))

(define-cstruct _dice
  ((nb-rolls _int)
   (nb-faces _int)
   (multiplier _float)
   (addsub _float)))

(define _random (_cpointer/null "tcod-random"))

(deftcod random-get-instance : -> _random)
(deftcod random-new : _random_algo -> _random)
(deftcod random-save : _random -> _random)
(deftcod random-restore : _random _random -> _random)
(deftcod random-new-from-seed : _uint32 -> _random)
(deftcod random-delete : _random -> _void)
(deftcod random-set-distribution : _random _distribution -> _void)

(deftcod random-get-int : _random _int _int -> _int)
(deftcod random-get-float : _random _float _float -> _float)
(deftcod random-get-double : _random _double _double -> _double)
(deftcod random-get-int-mean : _random _int _int _int -> _int)
(deftcod random-get-float-mean : _random _float _float _float -> _float)
(deftcod random-get-double-mean : _random _double _double _double -> _double)

(deftcod random-dice-new : _string -> _dice)
(deftcod random-dice-roll : _random _dice -> _int)
(deftcod random-dice-roll-s : _random _string -> _int)