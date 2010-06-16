#lang scheme

(require scheme/foreign
         "loader.scm"
         "color.scm"
         "console.scm")
(provide (all-defined-out))

(unsafe!)

(define _image (_cpointer/null "tcod-image"))

(deftcod image-new : _int _int -> _image)
(deftcod image-from-console : _console -> _image)
(deftcod image-refresh-console : _image _console -> _void)
(deftcod image-load : _string -> _image)
(deftcod image-clear : _image _color -> _void)
(deftcod image-invert : _image -> _void)
(deftcod image-hflip : _image -> _void)
(deftcod image-vflip : _image -> _void)
(deftcod image-scale : _image _int _int -> _void)
(deftcod image-save : _image _string -> _void)
(deftcod image-get-size : _image (w : (_ptr o _int)) (h : (_ptr o _int)) -> _void -> (list w h))
(deftcod image-get-pixel : _image _int _int -> _color)
(deftcod image-get-alpha : _image _int _int -> _int)
(deftcod image-get-mipmap-pixel : _image _float _float _float _float -> _color)
(deftcod image-put-pixel : _image _int _int _color -> _void)
; void TCOD_image_blit(TCOD_image_t image, TCOD_console_t console, float x, float y,  TCOD_bkgnd_flag_t bkgnd_flag, float scalex, float scaley, float angle);
(deftcod image-blit :
  _image _console _float _float _background _float _float _float -> _void)
; void TCOD_image_blit_rect(TCOD_image_t image, TCOD_console_t console, int x, int y, int w, int h, TCOD_bkgnd_flag_t bkgnd_flag);
(deftcod image-blit-rect :
  _image _console _int _int _int _int _background -> _void)
; void TCOD_image_blit_2x(TCOD_image_t image, TCOD_console_t dest, int dx, int dy, int sx, int sy, int w, int h);
(deftcod image-blit-2x :
  _image _console _int _int _int _int _int _int -> _void)
(deftcod image-delete : _image -> _void)
(deftcod image-set-key-color : _image _color -> _void)
(deftcod image-is-pixel-transparent? : _image _int _int -> _bool)