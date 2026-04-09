(in-package #:cl-user)

(defpackage #:tri.curves.bowdish
  (:use #:cl #:tri.base)
  (:export
    #:make-bowdish
    #:bowdish-default))

(in-package #:tri.curves.bowdish)


(in-package #:cl-user)

(defpackage #:tri.curves.bowdish
  (:use #:cl #:tri.base)
  (:export
    #:make-bowdish
    #:bowdish-default))

(in-package #:tri.curves.bowdish)

(defun make-bowdish (freq-x freq-y phase-x phase-y amp)
  "Return a function that computes a Bowditch/Lissajous point.
The returned function accepts a single argument TDEG (degrees 0–360)
and returns a list of two CSS calc() expressions: (X Y)."
  (lambda (tdeg)
    (list
     ;; X component
     (format nil
             "calc(~a * sin(calc(~a * ~,2fdeg + ~adeg)))"
             amp freq-x tdeg phase-x)
     ;; Y component
     (format nil
             "calc(~a * sin(calc(~a * ~,2fdeg + ~adeg)))"
             amp freq-y tdeg phase-y))))

(defun bowdish-default ()
  "The default TRIG Bowditch curve used by the theme compiler."
  (make-bowdish
   3   ; freq-x
   2   ; freq-y
   90  ; phase-x
   0   ; phase-y
   "var(--tri-amp)"))

