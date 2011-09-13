#lang racket

(require ffi/unsafe
         "loader.rkt"
         "color.rkt")
(provide (all-defined-out))

(define _background
  (_enum
   '(background-none
     background-set
     background-multiply
     background-lighten
     background-darken
     background-screen
     background-color-dodge
     background-color-burn
     background-add
     background-adda
     background-burn
     background-overlay
     background-alpha)))

(define _keycode
  (_enum
   '(key-none
     key-escape
     key-backspace
     key-tab
     key-enter
     key-shift
     key-control
     key-alt
     key-pause
     key-caps-lock
     key-page-up
     key-page-down
     key-end
     key-home
     key-up
     key-left
     key-right
     key-down
     key-print-screen
     key-insert
     key-delete
     key-left-windows
     key-right-windows
     key-apps
     key-0
     key-1
     key-2
     key-3
     key-4
     key-5
     key-6
     key-7
     key-8
     key-9
     keypad-0
     keypad-1
     keypad-2
     keypad-3
     keypad-4
     keypad-5
     keypad-6
     keypad-7
     keypad-8
     keypad-9
     keypad-add
     keypad-subtract
     keypad-divide
     keypad-multiply
     keypad-dec
     keypad-enter
     key-f1
     key-f2
     key-f3
     key-f4
     key-f5
     key-f6
     key-f7
     key-f8
     key-f9
     key-f10
     key-f11
     key-f12
     key-num-lock
     key-scroll-ock
     key-space
     key-char)))

(define _drawing-char
  (_enum
   '(; single walls
     char-hline 
     = 196
     char-vline
     = 179
     char-ne
     = 191
     char-nw
     = 218
     char-se
     = 217
     char-sw
     = 192
     char-tee-w
     = 180
     char-tee-e
     = 195
     char-tee-n
     = 193
     char-tee-s
     = 194
     char-cross
     = 197
     ; double walls
     char-dh-line
     = 205
     char-dv-line
     = 186
     char-dne
     = 197
     char-dnw
     = 201
     char-dse
     = 188
     char-dsw
     = 200
     char-dtee-w
     = 185
     char-dtee-e
     = 204
     char-dtee-n
     = 202
     char-dtee-s
     = 203
     char-dcross
     = 206
     ; blocks
     char-block-1
     = 176
     char-block-2
     char-block-3
     ; arrows
     char-arrow-n
     = 24
     char-arrow-s
     char-arrow-e
     char-arrow-w
     ; arrows without tail
     char-arrow2-n
     = 31
     char-arrow2-s
     char-arrow2-e
     = 16
     char-arrow2-w
     ; double arrows
     char-darrow-h
     = 29
     char-darrow-v
     = 18
     ; gui stuff
     char-checkbox-unset
     = 224
     char-checkbox-set
     char-radio-unset
     = 9
     char-radio-set
     ; subpixel resolution kit
     char-subpixel-nw
     = 226
     char-subpixel-ne
     char-subpixel-n
     char-subpixel-se
     char-subpixel-diag
     char-subpixel-e
     char-subpixel-sw)))

(define _color-control
  (_enum
   '(color-control-1
     = 1
     color-control-2
     color-control-3
     color-control-4
     color-control-5
     color-control-number
     = 5
     color-control-foreground-rgb
     color-control-background-rgb
     color-control-stop)))

(define _key-state
  (_enum '(key-pressed = 1 key-released)))

(define _font-flag
  (_bitmask 
   '(font-layout-ascii-in-col
     = 1
     font-layout-ascii-in-row
     = 2
     font-type-greyscale
     = 4
     font-type-grayscale
     = 4
     font-layout-tcod
     = 8)))

(define-cstruct _key
  ((vk _keycode)
   (c _uint8)
   (pressed _uint8)
   (left-alt _uint8)
   (left-ctrl _uint8)
   (right-alt _uint8)
   (right-ctrl _uint8)
   (shift _uint8)))

(define _renderer
  (_enum '(glsl opengl sdl num-renderers)))

(define _alignment
  (_enum '(left right center)))

(define _console (_cpointer/null "tcod-console"))

; void TCOD_console_init_root(int w, int h, const char * title, bool fullscreen);
(deftcod console-init-root : _int _int _string _bool _renderer -> _void)
(deftcod console-set-window-title : _string -> _void)
(deftcod console-set-fullscreen : _bool -> _void)
(deftcod console-is-fullscreen? : -> _bool)
(deftcod console-is-window-closed? : -> _bool)
; void TCOD_console_set_custom_font(const char *fontFile, int flags,int nb_char_horiz, int nb_char_vertic);
(deftcod console-set-custom-font : _string _font-flag _int _int -> _void)
; void TCOD_console_map_ascii_code_to_font(int asciiCode, int fontCharX, int fontCharY);
(deftcod console-map-ascii-code-to-font : _int _int _int -> _void)
; void TCOD_console_map_ascii_codes_to_font(int asciiCode, int nbCodes, int fontCharX, int fontCharY);
(deftcod console-map-ascii-codes-to-font : _int _int _int _int -> _void)
; void TCOD_console_map_string_to_font(const char *s, int fontCharX, int fontCharY);
(deftcod console-map-string-to-font : _string _int _int -> _void)

(deftcod console-set-dirty : _int _int _int _int -> _void)
(deftcod console-set-default-background : _console _color -> _void)
(deftcod console-set-default-foreground : _console _color -> _void)
(deftcod console-clear : _console -> _void)
(deftcod console-set-char-background : _console _int _int _color _background -> _void)
(deftcod console-set-char-foreground : _console _int _int _color -> _void)
; void TCOD_console_set_char(TCOD_console_t con,int x, int y, int c);
(deftcod console-set-char : _console _int _int _int -> _void)
(deftcod console-put-char : _console _int _int _int _background -> _void)
; void TCOD_console_put_char_ex(TCOD_console_t con,int x, int y, int c, TCOD_color_t fore, TCOD_color_t back)
(deftcod console-put-char-ex : _console _int _int _int _color _color -> _void)

(deftcod console-set-background-flag! : _console _background -> _void)
(deftcod console-get-background-flag : _console -> _background)

(deftcod console-set-alignment! : _console _alignment -> _void)
(deftcod console-get-alignment : _console -> _alignment)

(deftcod console-print : _console _int _int _string -> _void)
(deftcod console-print-ex : _console _int _int _background _alignment
  _string -> _void)

(deftcod console-print-rect : _console _int _int _int _int _string ->
  _int)
(deftcod console-print-rect-ex : _console _int _int _int _int
  _background _alignment _string -> _int)
(deftcod console-get-height-rect : _console _int _int _int _int
  _string -> _int)
  
; void TCOD_console_rect(TCOD_console_t con,int x, int y, int w, int h, bool clear, TCOD_bkgnd_flag_t flag);
(deftcod console-rect : _console _int _int _int _int _bool _background -> _void)
; void TCOD_console_hline(TCOD_console_t con,int x,int y, int l, TCOD_bkgnd_flag_t flag);
(deftcod console-hline : _console _int _int _int _background -> _void)
(deftcod console-vline : _console _int _int _int _background -> _void)

;; console-print-frame
(deftcod console-print-frame : _console _int _int _int _int _bool _background _string -> _void)
;; unicode formattings
(deftcod console-map-string-to-font-utf : _string/utf-16 _int _int -> _void)
(deftcod console-print-utf : _console _int _int _string/utf-16 ->
  _void)
(deftcod console-print-ex-utf : _console _int _int _background
  _alignment _string/utf-16 -> _void)
(deftcod console-print-rect-ex-utf : _console _int _int _int _int
  _background _alignment _string/utf-16 -> _int)
(deftcod console-get-height-rect-utf : _console _int _int _int _int
  _string/utf-16 -> _int)


(deftcod console-get-default-background : _console -> _color)
(deftcod console-get-default-foreground : _console -> _color)
(deftcod console-get-char-background : _console _int _int -> _color)
(deftcod console-get-char-foreground : _console _int _int -> _color)
(deftcod console-get-char : _console _int _int -> _int)

(deftcod console-set-fade : _uint8 _color -> _void)
(deftcod console-get-fade : -> _uint8)
(deftcod console-get-fading-color : -> _color)

(deftcod console-flush : -> _void)

(deftcod console-set-color-control : _color-control _color _color -> _void)

; void TCOD_console_set_keyboard_repeat(int initial_delay, int interval);
(deftcod console-set-keyboard-repeat : _int _int -> _void)
(deftcod console-disable-keyboard-repeat : -> _void)
(deftcod console-is-key-pressed? : _keycode -> _bool)

(deftcod console-from-file : _string -> _console)
(deftcod console-load-asc : _console _string -> _bool)
(deftcod console-save-asc : _console _string -> _bool)

(deftcod console-new : _int _int -> _console)
(deftcod console-get-width : _console -> _int)
(deftcod console-get-height : _console -> _int)
(deftcod console-set-key-color : _console _color -> _void)
; void TCOD_console_blit(TCOD_console_t src,int xSrc, int ySrc, int wSrc, int hSrc, TCOD_console_t dst, int xDst, int yDst, float foreground_alpha, float background_alpha);
(deftcod console-blit : _console _int _int _int _int _console _int _int _float _float ->
  _void)
(deftcod console-delete : _console -> _void)
(deftcod console-credits : -> _void)
(deftcod console-credits-reset : -> _void)
(deftcod console-credits-render : _int _int _bool -> _bool)

