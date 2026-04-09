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
(load (merge-pathnames "nex-debug.lisp" *nexus-lisp-dir*))
(load (merge-pathnames "nex-expand.lisp" *nexus-lisp-dir*))

(in-package #:cl-user)

(print
 (nx-expand:nx-expand-outer
  '(("a" "b" ("c" "d" ("e" "f"))) "g" ("h" "i") "j")))

