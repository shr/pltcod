#lang racket

(require ffi/unsafe
         "loader.rkt"
         "color.rkt"
         "console.rkt")

(define _text (_cpointer/null "tcod-text"))


; TCOD_text_t TCOD_text_init (int x, int y, int w, int h, int max_chars, int cursor_char, int blink_interval, char * prompt, TCOD_color_t fore, TCOD_color_t back, float back_transparency, bool multiline);
(deftcod text-init : _int _int _int _int _int _int _int _string _color _color _float _bool -> _text)
(deftcod text-update : _text _key -> _bool)
(deftcod text-render : _console _text -> _void)
(deftcod text-get : _text -> _string)
(deftcod text-reset : _text -> _void)
(deftcod text-delete : _text -> _void)
