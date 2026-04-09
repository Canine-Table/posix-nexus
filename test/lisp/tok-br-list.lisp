#!/usr/bin/sbcl --script

(require :uiop)

(defparameter *nexus-lib*
  (uiop:ensure-directory-pathname (uiop:getenv "NEXUS_LIB")))

(unless *nexus-lib*
  (error "Environment variable NEXUS_LIB is not set."))

(defparameter *nexus-lisp-dir*
  (merge-pathnames "lisp/cl/" *nexus-lib*))

(load (merge-pathnames "struct.d/nex-queue.lisp" *nexus-lisp-dir*))
(load (merge-pathnames "stream.d/nex-token.lisp" *nexus-lisp-dir*))

(in-package #:nx-stream.token)

(format t "~&--- nx-tok-br brand tests ---~%")

(format t "~&Test 1: atom + atom~%")
(print (nx-tok-br "a" "b" "c"))

(format t "~&~%Test 2: atom + flat list~%")
(print (nx-tok-br "a" '("x" "y" "z")))


(format t "~&~%Test 3: atom + double list~%")
(print (nx-tok-br "a" '(("x" "y") ("u" "v"))))

(format t "~&~%Test 4: mixed sequence~%")
(print (nx-tok-br "a" '("x") '(("y") ("z")) "b"))

