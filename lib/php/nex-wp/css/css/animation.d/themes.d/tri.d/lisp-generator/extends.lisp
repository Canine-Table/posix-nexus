(in-package #:cl-user)


(defpackage #:tri.extends
  (:use #:cl #:tri.base)
  (:export
    #:define-css-block
    #:extend-css
    #:define-css-mixin
    #:apply-css-mixin
    #:*css-blocks*
    #:*css-mixins*))

(in-package #:tri.extends)

;; Registry for reusable CSS blocks
(defparameter *css-blocks* (make-hash-table :test 'equal))

(defun define-css-block (name properties)
  "Register a reusable CSS block under NAME."
  (setf (gethash name *css-blocks*) properties))

(defun extend-css (out block-name selector)
  "Emit CSS for SELECTOR using the properties stored in BLOCK-NAME."
  (let ((props (gethash block-name *css-blocks*)))
    (emit-line out "~a {" selector)
    (dolist (p props)
      (emit-line out "  ~a" p))
    (emit-line out "}")))

;; Registry for mixins
(defparameter *css-mixins* (make-hash-table :test 'equal))

(defun define-css-mixin (name lambda-fn)
  "Register a mixin NAME that produces CSS properties via LAMBDA-FN."
  (setf (gethash name *css-mixins*) lambda-fn))

(defun apply-css-mixin (out mixin-name selector &rest args)
  "Emit CSS for SELECTOR using the mixin MIXIN-NAME with ARGS."
  (let* ((fn (gethash mixin-name *css-mixins*))
         (props (apply fn args)))
    (emit-line out "~a {" selector)
    (dolist (p props)
      (emit-line out "  ~a" p))
    (emit-line out "}")))

