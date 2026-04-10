#!/usr/bin/sbcl --script

(require :uiop)

(defparameter *nexus-lib*
  (uiop:ensure-directory-pathname (uiop:getenv "NEXUS_LIB")))

(defparameter *nexus-lisp-dir*
  (merge-pathnames "lisp/cl/" *nexus-lib*))

(load (merge-pathnames "struct.d/nex-queue.lisp" *nexus-lisp-dir*))
(load (merge-pathnames "stream.d/nex-token.lisp" *nexus-lisp-dir*))

(in-package #:nx-stream.token)

(format t "~&--- (nx-crop-merge '(a b) '(1 2)) ---~%")
(print (nx-crop-merge '("a" "b") '("1" "2")))

(format t "~&--- (nx-crop-merge '(a '(1 2)) ---~%")
(print (nx-normalize '("a" ("1" "2"))))


(format t "~&--- (nx-crop-merge '(a '(1 2)) ---~%")
(print (nx-normalize-rest "a" '("1" "2")))
