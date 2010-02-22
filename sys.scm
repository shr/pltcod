#lang scheme

(require scheme/foreign
         "loader.scm"
         "image.scm"
         "list.scm")
(provide (all-defined-out))

(unsafe!)

(deftcod sys-elapsed-milli : -> _uint32)
(deftcod sys-elapsed-seconds : -> _float)
(deftcod sys-sleep-milli : _uint32 -> _void)
(deftcod sys-save-screenshot : _string -> _void)
(deftcod sys-force-fullscreen-resolution : _int _int -> _void)
(deftcod sys-set-fps : _int -> _void)
(deftcod sys-get-fps : -> _int)
(deftcod sys-get-last-frame-length : -> _float)
(deftcod sys-get-current-resolution : (w : (_ptr o _int)) (h : (_ptr o _int)) -> _void
  -> (list w h))
; void TCOD_sys_update_char(int asciiCode, int fontx, int fonty, TCOD_image_t img, int x, int y);
(deftcod sys-update-char : _int _int _int _image _int _int -> _void)
(deftcod sys-create-directory : _string -> _bool)
(deftcod sys-delete-file : _string -> _bool)
(deftcod sys-delete-directory : _string -> _bool)
(deftcod sys-is-directory? : _string -> _bool)
(deftcod sys-get-directory-content : _string _string -> _lst)

;;; should we really use this?

(define _thread (_cpointer/null "tcod-thread"))
(define _semaphore (_cpointer/null "tcod-semaphore"))
(define _mutex (_cpointer/null "tcod-mutex"))
(define _cond (_cpointer/null "tcod-cond"))

(define _void*->int (_fun _pointer -> _int))

(deftcod thread-new : _void*->int _pointer -> _thread)
(deftcod thread-delete : _thread -> _void)
(deftcod sys-get-num-cores : -> _int)
(deftcod thread-wait : _thread -> _void)

(deftcod mutex-new : -> _mutex)
(deftcod mutex-in : _mutex -> _void)
(deftcod mutex-out : _mutex -> _void)
(deftcod mutex-delete : _mutex -> _void)

(deftcod semaphore-new : _int -> _semaphore)
(deftcod semaphore-lock : _semaphore -> _void)
(deftcod semaphore-unlock : _semaphore -> _void)
(deftcod semaphore-delete : _semaphore -> _void)

(deftcod condition-new : -> _cond)
(deftcod condition-signal : _cond -> _void)
(deftcod condition-broadcast : _cond -> _void)
(deftcod condition-wait : _cond _mutex -> _void)
(deftcod condition-delete : _cond -> _void)

;;; SDL renderer