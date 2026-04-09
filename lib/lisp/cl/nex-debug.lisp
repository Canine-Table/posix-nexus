(defpackage :nx-debug
  (:use :cl)
  (:export
   :*nx-trace*
   :nx-trace-on
   :nx-trace-off
   :nx-trace))

(in-package :nx-debug)

(defparameter *nx-trace* nil
  "Global toggle for all NX tracing output.")

(defun nx-trace-on ()
  (setf *nx-trace* t))

(defun nx-trace-off ()
  (setf *nx-trace* nil))

(defun nx-trace (fmt &rest args)
  (when *nx-trace*
    (apply #'format t fmt args)))

