ckage :nx-stream.accumulator
  (:use :cl)
  (:export :make-acm :acm-data))

(in-package :nx-stream.accumulator)

(defstruct acm
	  data) ;; always a list

