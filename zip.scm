#lang scheme

(require scheme/foreign
         "loader.scm"
         "color.scm"
         "console.scm"
         "image.scm")
(provide* (all-defined-out))

(unsafe!)

(define _zip (_cpointer/null "tcod-zip"))

(deftcod zip-new : -> _zip)
(deftcod zip-delete : _zip -> _void)

(deftcod zip-put-char : _zip _uint8 -> _void)
(deftcod zip-put-int : _zip _int -> _void)
(deftcod zip-put-float : _zip _float -> _void)
(deftcod zip-put-string : _zip _string -> _void)
(deftcod zip-put-color : _zip _color -> _void)
(deftcod zip-put-image : _zip _image -> _void)
(deftcod zip-put-console : _zip _console -> _void)
(deftcod zip-put-data : _zip (l : _int) (_bytes o l) -> _void)
(deftcod zip-save-to-file : _zip _string -> _int)

(deftcod zip-load-from-file : _zip  _string -> _int)
(deftcod zip-get-char : _zip -> _uint8)
(deftcod zip-get-int : _zip -> _int)
(deftcod zip-get-float : _zip -> _float)
(deftcod zip-get-string : _zip -> _string)
(deftcod zip-get-color : _zip -> _color)
(deftcod zip-get-image : _zip -> _image)
(deftcod zip-get-console : _zip -> _console)
(deftcod zip-get-data : _zip (l : _int) (v : (_bytes o l)) -> _int -> v)