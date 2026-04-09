#!/usr/bin/sbcl --script

(require :uiop)

(defparameter *nexus-lib*
  (uiop:ensure-directory-pathname (uiop:getenv "NEXUS_LIB")))

(defparameter *nexus-lisp-dir*
  (merge-pathnames "lisp/cl/" *nexus-lib*))

(load (merge-pathnames "struct.d/nex-queue.lisp" *nexus-lisp-dir*))
(load (merge-pathnames "stream.d/nex-token.lisp" *nexus-lisp-dir*))

(in-package #:nx-stream.token)

(format t "~&--- nx-tok-br minimal behavior tests ---~%")

(format t "~&atom + atom → ~S~%"
        (nx-tok-br "a" "b"))

(format t "~&atom + flat list → ~S~%"
        (nx-tok-br "a" '("x" "y")))

(format t "~&atom + double list → ~S~%"
        (nx-tok-br "a" '(("x" "y") ("u" "v"))))

(format t "~&flat list + atom → ~S~%"
        (nx-tok-br '("x" "y") "z"))

(format t "~&flat list + flat list → ~S~%"
        (nx-tok-br '("a" "b") '("x" "y")))

(format t "~&flat list + double list → ~S~%"
        (nx-tok-br '("a" "b") '(("x") ("y" "z"))))

(format t "~&double list + atom → ~S~%"
        (nx-tok-br '(("a" "b") ("c")) "z"))

(format t "~&flat list + flat list → ~S~%"
        (nx-tok-br '("a" "b") '("x" "y")))

(format t "~&double list + double list → ~S~%"
        (nx-tok-br '(("a" "b") ("c"))
                   '(("x") ("y" "z"))))

(format t "~&double list + atom → ~S~%"
				(nx-tok-br '(
										 ("width" "height") ":3rem"
										 )";"))

