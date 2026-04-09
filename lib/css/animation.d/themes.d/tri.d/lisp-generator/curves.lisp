(in-package #:cl-user)

(defpackage #:tri.curves
  (:use #:cl #:tri.base)
  (:import-from #:tri.curves.bowdish
    #:bowdish-default)
  (:export
    #:get-curve
    #:gen-curve))

(in-package #:tri.curves)

(load "curves.d/bowdish.lisp")

(defun get-curve (name)
  (ecase name
    (:bowdish (bowdish-default))))


(defun gen-curve (stream name fn &key (samples 200))
  "Emit @keyframes NAME using curve function FN."
  (emit-line stream "@keyframes ~a {" name)
  (loop for i from 0 to samples do
    (let* ((pct (* 100 (/ i samples)))
           (tdeg (* 360 (/ i samples)))
           (xy (funcall fn tdeg)))
      (emit-line stream "  ~,2f% { background-position: ~a ~a; }"
                 pct (first xy) (second xy))))
  (emit-line stream "}"))
#|
(defun gen-curve (stream name fn &key (samples 200))
  "Emit @keyframes NAME using curve function FN."
  (emit-line stream "@keyframes ~a {" name)
  (loop for i from 0 to samples do
    (let* ((pct (* 100 (/ i samples)))
           (tdeg (* 360 (/ i samples)))
           (xy (funcall fn tdeg)))
			(emit-line stream "  ~,2f% { background-position: ~a ~a; }"
           pct (first xy) (second xy))
      (emit-line stream "  ~,2f% { transform: translate(~a, ~a); }"
                 pct (first xy) (second xy))))
  (emit-line stream "}"))
|#
