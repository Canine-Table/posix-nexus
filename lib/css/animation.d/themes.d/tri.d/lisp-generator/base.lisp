;;;; ============================================================
;;;; TRIG THEME COMPILER — BASE UTILITIES
;;;; File: theme/tri/base.lisp
;;;; ============================================================

(in-package #:cl-user)
(defpackage #:tri.base
  (:use #:cl)
  (:export
    #:deg
    #:sin-deg
    #:cos-deg
    #:emit
    #:emit-line
    #:with-css-file))

(in-package #:tri.base)

;;; ------------------------------------------------------------
;;; Angle helpers
;;; ------------------------------------------------------------

(defun deg (x)
  "Convert degrees to radians."
  (* x (/ pi 180)))

(defun sin-deg (x)
  "Sine of an angle in degrees."
  (sin (deg x)))

(defun cos-deg (x)
  "Cosine of an angle in degrees."
  (cos (deg x)))

;;; ------------------------------------------------------------
;;; CSS emission helpers
;;; ------------------------------------------------------------

(defun emit (stream fmt &rest args)
  "Write formatted CSS to STREAM."
  (apply #'format stream fmt args))

(defun emit-line (stream fmt &rest args)
  "Write a formatted CSS line with newline."
  (apply #'format stream (concatenate 'string fmt "~%") args))

(defmacro with-css-file ((var filename) &body body)
  "Open a CSS file for writing and bind VAR to the stream."
  `(with-open-file (,var ,filename
                         :direction :output
                         :if-exists :supersede
                         :if-does-not-exist :create)
     ,@body))


