#lang scheme

(require scheme/foreign
         "loader.scm"
         "mersenne.scm")
(provide (all-defined-out))

(unsafe!)

(define _noise (_cpointer/null "tcod-noise"))
(define _floatvec (_vector i _float))

; TCOD_noise_t TCOD_noise_new(int dimensions, float hurst, float lacunarity, TCOD_random_t random);
(deftcod noise-new : _int _float _float _random -> _noise)
(deftcod noise-perlin : _noise _floatvec -> _float)
(deftcod noise-fbm-perlin : _noise _floatvec _float -> _float)
(deftcod noise-turbulence-perlin : _noise _floatvec _float -> _float)
(deftcod noise-simplex : _noise _floatvec -> _float)
(deftcod noise-fbm-simplex : _noise _floatvec _float -> _float)
(deftcod noise-turbulence-simplex : _noise _floatvec _float -> _float)
(deftcod noise-wavelet : _noise _floatvec -> _float)
(deftcod noise-fbm-wavelet : _noise _floatvec _float -> _float)
(deftcod noise-turbulence-wavelet : _noise _floatvec _float -> _float)
(deftcod noise-delete : _noise -> _void)