#lang racket

(require (planet jaymccarthy/matrix))
(require "libtcod.rkt")

;;; any object in the dungeon
(define visible-dungeon-object%
  (class object%
    (init x: y: char: color:)
    (define x x:)
    (define y y:)
    (define char char:)
    (define color color:)
    
    (super-new)
    
    (define/public (move a-map dx dy)
      (when (and (matrix-valid-ref? a-map (+ x dx) (+ y dy))
                 (not (send (matrix-ref a-map (+ x dx) (+ y dy)) blocked?)))
        (move-to! (+ x dx) (+ y dy))))
    
    (define/public (move-to! u v)
      (set! x u)
      (set! y v))
    (define/public (get-x) x)
    (define/public (get-y) y)
    
    (define/public (draw console fov-map)
      (when (tcod:map-is-in-fov? fov-map x y)
        (tcod:console-set-default-foreground console color)
        (tcod:console-put-char console x y (char->integer char)
                               'background-none)))
    
    (define/public (clear console)
      (tcod:console-put-char console x y (char->integer #\space)
                             'background-none))))

(define dungeon-tile%
  (class object%
    (init blocked: transparent:)
    (define blocked blocked:)
    (define transparent transparent:)
    (define explored #f)
    
    (super-new)
    
    (define/public (blocked?) blocked)
    (define/public (transparent?) transparent)
    (define/public (make-blocked v) (set! blocked v))
    (define/public (make-transparent v) (set! transparent v))
    (define/public (explored?) explored)
    (define/public (set-explored!) (set! explored #t))))

(define room%
  (class object%
    (init x: y: w: h:)
    (define x1 x:)
    (define y1 y:)
    (define x2 (+ x: w:))
    (define y2 (+ y: h:))
    
    (super-new)
    
    (define/public (x-indices/room) (in-range (+ 1 x1) x2))
    (define/public (y-indices/room) (in-range (+ 1 y1) y2))
    (define/public (x-indices/path) (in-range (min x1 x2) (+ 1 (max x1 x2))))
    (define/public (y-indices/path) (in-range (min y1 y2) (+ 1 (max y1 y2))))
    
    (define/public (get-x1) x1)
    (define/public (get-x2) x2)
    (define/public (get-y1) y1)
    (define/public (get-y2) y2)
    
    (define/public (center) (cons (quotient (+ x1 x2) 2)
                                  (quotient (+ y1 y2) 2)))
    (define/public (intersects? r2)
      (and (<= x1 (send r2 get-x2))
           (>= x2 (send r2 get-x1))
           (<= y1 (send r2 get-y2))
           (>= y2 (send r2 get-y1))))))

(define screen-width 80)
(define screen-height 50)
(define limit-fps 20)

(define player-x 4)
(define player-y 4)

(define map-width 75)
(define map-height 45)

(define (create-room room a-map)
  (for ((x (send room x-indices/room)))
       (for ((y (send room y-indices/room)))
            (send (matrix-ref a-map x y) make-blocked #f)
            (send (matrix-ref a-map x y) make-transparent #t))))

(define (create-h-path a-map x1 x2 y)
  (for ((x (in-range (min x1 x2) (+ 1 (max x1 x2)))))
       (dig-at a-map x y)))

(define (create-v-path a-map y1 y2 x)
  (for ((y (in-range (min y1 y2) (+ 1 (max y1 y2)))))
       (dig-at a-map x y)))

(define (dig-at a-map x y)
  (send (matrix-ref a-map x y) make-blocked #f)
  (send (matrix-ref a-map x y) make-transparent #t))

(define (bresenham-path a-map x1 y1 x2 y2)
  (tcod:line-mt x1 y1 x2 y2
                (λ (x y) (dig-at a-map x y))))

(define room-max-size 10)
(define room-min-size 6)
(define max-rooms 30)

(define (random-rooms)
  (for/list ((i (in-range max-rooms)))
            (let ([w (tcod:random-get-int #f room-min-size room-max-size)]
                  [h (tcod:random-get-int #f room-min-size room-max-size)])
              (new room% [x: (tcod:random-get-int #f 0 (- map-width w 1))]
                   [y: (tcod:random-get-int #f 0 (- map-height h 1))]
                   [w: w] [h: h]))))

(define (intersects? a-room rooms)
  (if (null? rooms) #f
      (if (send a-room intersects? (car rooms))
          #t
          (intersects? a-room (cdr rooms)))))

(define (room-creator dungeon-map player)
  (let ([valid-rooms
         (foldr (lambda (room result)
                  (if (intersects? room result)
                      result
                      (cons room result))) '() (random-rooms))])
    (map (λ (r) (create-room r dungeon-map)) valid-rooms)
    (unless (null? valid-rooms)
      (let ([c (send (car valid-rooms) center)])
        (send player move-to! (car c) (cdr c)))
      (let loop ([r (car valid-rooms)]
                 [other (cdr valid-rooms)])
        (unless (null? other)
          (let ([c1 (send r center)]
                [c2 (send (car other) center)])
            (if (even? (tcod:random-get-int #f 0 10))
                (create-h-path dungeon-map (car c1) (car c2) (cdr c1))
                (create-v-path dungeon-map (cdr c1) (cdr c2) (car c1)))
            (bresenham-path dungeon-map (car c1) (cdr c1) (car c2) (cdr c2)))
          (loop (car other) (cdr other)))))))



(define (make-map player)
  (let ([dungeon-map (build-matrix map-width map-height
                                   (λ (x y)
                                       (new dungeon-tile% [blocked: #t] [transparent: #f])))])
    (room-creator dungeon-map player)
    dungeon-map))

(define color-dark-wall (tcod:make-color 0 0 100))
(define color-light-wall (tcod:make-color 130 110 50))
(define color-dark-ground (tcod:make-color 50 50 150))
(define color-light-ground (tcod:make-color 200 180 50))

(define (handle-keys dungeon-map player)
  (call/cc (lambda (k)
             (let-values ([(r key m) (tcod:sys-wait-for-event 'key-press #f)])
               (let* ([vk (tcod:key-vk key)]
                      [char (integer->char (tcod:key-c key))])
                 (send player clear #f)
                 (set! recompute-fov #f)
                 (printf "~s ~s~n" vk char)
                 (cond
                   [(and (eq? 'key-enter vk) (tcod:key-left-alt key))
                    (tcod:console-set-fullscreen (not (tcod:console-is-fullscreen?)))
                    (k #f)]
                   [(or (eq? 'key-escape vk) (and (eq? 'key-char vk)
                                                  (eq? char #\Q)
                                                  (tcod:key-left-ctrl key)))
                    (k #t)] ; shortcut
                   [(or (eq? vk 'key-up) (eq? vk 'keypad-8))
                    (send player move dungeon-map 0 -1)]
                   [(or (eq? vk 'key-down) (eq? vk 'keypad-2))
                    (send player move dungeon-map 0 1)]
                   [(or (eq? vk 'key-left) (eq? vk 'keypad-4))
                    (send player move dungeon-map -1 0)]
                   [(or (eq? vk 'key-right) (eq? vk 'keypad-6))
                    (send player move dungeon-map 1 0)]
                   [(eq? vk 'keypad-7)
                    (send player move dungeon-map -1 -1)]
                   [(eq? vk 'keypad-9)
                    (send player move dungeon-map 1 -1)]
                   [(eq? vk 'keypad-3)
                    (send player move dungeon-map 1 1)]
                   [(eq? vk 'keypad-1)
                    (send player move dungeon-map -1 1)])
                 (set! recompute-fov #t)
                 #f)))))

(define (on-all fn all . args)
  (map (λ (x) (send x fn . args)) all))

(define (render-all dungeon-map fov-map objs console)
  (map (λ (x) (send x draw console fov-map)) objs)
  (for ((y (in-range map-height)))
       (for ((x (in-range map-width)))
            (let ([visible (tcod:map-is-in-fov? fov-map x y)]
                  [pv (matrix-ref dungeon-map x y)])
              (when visible
                (send pv set-explored!))
              (when (send pv explored?)
                (tcod:console-set-char-background
                 console x y
                 (if (send (matrix-ref dungeon-map x y) transparent?)
                     (if visible color-light-ground color-dark-ground)
                     (if visible color-light-wall color-dark-wall)) 'background-set))))))

(define (set-fov-map-properties dungeon-map fov-map)
  (for ([y (in-range map-height)])
       (for ([x (in-range map-width)])
            (tcod:map-set-properties fov-map x y
                                     (not (send (matrix-ref dungeon-map x y) blocked?))
                                     (send (matrix-ref dungeon-map x y) transparent?)))))

(define recompute-fov #t)
(define torch-radius 6)
(define fov-light-walls #t)
(define fov-algo 'fov-shadow)

(define (fov-computer fov-map player)
  (tcod:map-compute-fov fov-map (send player get-x) (send player get-y) torch-radius fov-light-walls fov-algo))

(define (main-loop)
  (tcod:console-set-custom-font "data/fonts/prestige12x12_gs_tc.png"
  '(font-layout-tcod font-type-greyscale) -1 -1)
  (tcod:console-init-root screen-width screen-height "scheme/libtcod tutorial" #f 'sdl)
  (tcod:sys-set-fps limit-fps)
  (let* ([player (new visible-dungeon-object%
                      [x: player-x]
                      [y: player-y]
                      [char: #\@]
                      [color: tcod:white])]
         [npc (new visible-dungeon-object%
                   [x: (- player-x 1)]
                   [y: player-y]
                   [char: #\p]
                   [color: tcod:yellow])]
         [objects (list player npc)]
         [dungeon-map (make-map player)]
         [fov-map (tcod:map-new map-width map-height)])
    (set-fov-map-properties dungeon-map fov-map)
    (let loop ([first #t])
      (unless (tcod:console-is-window-closed?)
        (when first
          (render-all dungeon-map fov-map objects #f)
          (tcod:console-flush))
        (let ([break [and (not first) (handle-keys dungeon-map player)]])
          (unless break
            (when recompute-fov
              (set! recompute-fov #f)
              (fov-computer fov-map player))
            (render-all dungeon-map fov-map objects #f)
            (tcod:console-flush)
            (loop #f))
          (tcod:sys-term))))))

(main-loop)
