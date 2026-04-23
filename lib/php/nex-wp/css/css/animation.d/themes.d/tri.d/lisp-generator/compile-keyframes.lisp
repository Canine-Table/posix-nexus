(in-package #:cl-user)

(defpackage #:tri.compile-keyframes
  (:use #:cl
        #:tri.base
        #:tri.curves)
  (:export #:compile-keyframes))

(in-package #:tri.compile-keyframes)

(defun compile-keyframes ()
  (with-css-file (out "../nex-keyframes.css")
    (emit-line out "/* generated keyframes */")

    ;; Ask registry for the curve function
    (let ((curve (get-curve :bowdish)))
      (gen-curve out
                 "nx-tri-bowdish-curve"
                 curve
                 :samples 200))))

