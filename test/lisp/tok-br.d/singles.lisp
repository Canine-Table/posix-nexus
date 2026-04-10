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
(load (merge-pathnames "stream.d/nex-token.lisp" *nexus-lisp-dir*))

(in-package #:nx-stream.token)


(format t "~&test A: ~S~%" (nx-normalize-singletons
	'(((1 2) ((((((3))))))) ((((((4))))))
	1) 2 3
	'("hello" "world") "bye"))

