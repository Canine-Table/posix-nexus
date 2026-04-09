(in-package #:cl-user)
(defpackage #:nx-stream.io
  (:use #:cl)
  (:export
    #:nx-emit
    #:nx-emit-line
    #:nx-with-file))

(in-package #:nx-stream.io)

(defun nx-emit (stream fmt &rest args)
  "Write to STREAM."
  (apply #'format stream fmt args))

(defun nx-emit-line (stream fmt &rest args)
  "Write a formatted line with newline."
  (apply #'format stream (concatenate 'string fmt "~%") args))

(defmacro nx-with-file ((var filename) &body body)
  "Open a file for writing and bind VAR to the stream."
  `(with-open-file (,var ,filename
                         :direction :output
                         :if-exists :supersede
                         :if-does-not-exist :create)
     ,@body))


(in-package #:cl-user)

