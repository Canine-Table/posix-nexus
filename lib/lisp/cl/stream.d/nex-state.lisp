(defpackage :nx-stream.state
  (:use :cl)
  (:export :make-state :state-acm :state-queue))

(in-package :nx-stream.state)

(defstruct state
  acm
  queue)

