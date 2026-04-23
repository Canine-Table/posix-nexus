#!/usr/bin/sbcl --script

(load (merge-pathnames
       "base.lisp"
       (make-pathname :directory (pathname-directory *load-pathname*))))

(load (merge-pathnames
       "curves.d/bowdish.lisp"
       (make-pathname :directory (pathname-directory *load-pathname*))))

(load (merge-pathnames
       "curves.lisp"
       (make-pathname :directory (pathname-directory *load-pathname*))))

(load (merge-pathnames
       "compile-keyframes.lisp"
       (make-pathname :directory (pathname-directory *load-pathname*))))

(load (merge-pathnames
       "compile-theme.lisp"
       (make-pathname :directory (pathname-directory *load-pathname*))))

(load (merge-pathnames
       "compile-layout.lisp"
       (make-pathname :directory (pathname-directory *load-pathname*))))

;; ⭐ Load tri.extends BEFORE compile-style
(load (merge-pathnames
       "extends.lisp"
       (make-pathname :directory (pathname-directory *load-pathname*))))

(load (merge-pathnames
       "compile-style.lisp"
       (make-pathname :directory (pathname-directory *load-pathname*))))

(in-package #:cl-user)

(tri.compile-keyframes:compile-keyframes)
(tri.compile-layout:compile-layout)
(tri.compile-style:compile-style)
