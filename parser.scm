#lang scheme

(require scheme/foreign
         "loader.scm")

(unsafe!)

(define _value-type
  (_enum
   '(type-none
     type-bool
     type-char
     type-int
     type-float
     type-string
     type-color
     type-dice
     type-value-list-00
     type-value-list-01
     type-value-list-02
     type-value-list-03
     type-value-list-04
     type-value-list-05
     type-value-list-06
     type-value-list-07
     type-value-list-08
     type-value-list-09
     type-value-list-10
     type-value-list-11
     type-value-list-12
     type-value-list-13
     type-value-list-14
     type-value-list-15
     type-custom-00
     type-custom-01
     type-custom-02
     type-custom-03
     type-custom-04
     type-custom-05
     type-custom-06
     type-custom-07
     type-custom-08
     type-custom-09
     type-custom-10
     type-custom-11
     type-custom-12
     type-custom-13
     type-custom-14
     type-custom-15
     type-list = 1024)))

(define-cstruct _dice
  ((number-dice _int)
   (number-faces _int)
   (multiplier _float)
   (addsub _float)))
