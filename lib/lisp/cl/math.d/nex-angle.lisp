(in-package #:cl-user)
(defpackage #:nx-math.angle
  (:use #:cl)
  (:export
    #:nx-deg
    #:nx-sin-deg
    #:nx-cos-deg))

(in-package #:nx-math.angle)

;;; ------------------------------------------------------------
;;; Angle helpers
;;; ------------------------------------------------------------

(defun nx-deg (x)
  "Convert degrees to radians."
  (* x (/ pi 180)))

(defun nx-sin-deg (x)
  "Sine of an angle in degrees."
  (sin (nx-deg x)))

(defun nx-cos-deg (x)
  "Cosine of an angle in degrees."
  (cos (nx-deg x)))

