#!/usr/bin/sbcl --script

(require :uiop)

;; Normalize NEXUS_LIB so it ends with a slash
(defparameter *nexus-lib*
	(uiop:ensure-directory-pathname (uiop:getenv "NEXUS_LIB")))

(unless *nexus-lib*
	(error "Environment variable NEXUS_LIB is not set."))

;; Build correct path
(defparameter *nexus-lisp-dir*
	(merge-pathnames "lisp/cl/" *nexus-lib*))

;; Load modules
(load (merge-pathnames "struct.d/nex-queue.lisp" *nexus-lisp-dir*))

(in-package #:nx-struct.queue)

(let ((q (nx-make-queue)))
  (format t "~&Queue created: ~S~%" q)

  (nx-enqueue 'a q)
  (nx-enqueue 'b q)
  (nx-enqueue 'c q)
  (nx-enqueue 'd q)
  (nx-enqueue 'e q)
  (nx-enqueue 'f q)

  (format t "~&After enqueues: ~S~%" q)

  (format t "~&Dequeue: ~S~%" (nx-dequeue q))
  (format t "~&Queue now: ~S~%" q)

  (format t "~&Dequeue: ~S~%" (nx-dequeue q))
  (format t "~&Queue now: ~S~%" q)

  (format t "~&Dequeue: ~S~%" (nx-dequeue q))
  (format t "~&Queue now: ~S~%" q)

  (format t "~&Dequeue: ~S~%" (nx-dequeue q))
  (format t "~&Queue now: ~S~%" q)

  (format t "~&Dequeue: ~S~%" (nx-dequeue q))
  (format t "~&Queue now: ~S~%" q)

  (format t "~&Dequeue: ~S~%" (nx-dequeue q))
  (format t "~&Queue now: ~S~%" q)

  (format t "~&Dequeue: ~S~%" (nx-dequeue q))
  (format t "~&Queue now: ~S~%" q)

  (format t "~&Dequeue: ~S~%" (nx-dequeue q))
  (format t "~&Queue now: ~S~%" q))

