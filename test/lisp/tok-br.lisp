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

(format t "~&--- nx-tok-br tests ---~%")

(format t "~&Test 1: simple atoms~%")
(nx-tok-br 'a 'b 'c 'd)

(format t "~&~%Test 2: mix of atoms and lists~%")
(nx-tok-br 'a '(x y) 'b '(c d) 'e)

(format t "~&~%Test 3: single token~%")
(nx-tok-br 'solo)

(format t "~&~%Test 4: empty call~%")
(nx-tok-br)

