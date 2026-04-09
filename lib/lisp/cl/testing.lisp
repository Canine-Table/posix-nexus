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

(defun nx-crop-merge (a b)
	(loop for x in a
				for y in b
				collect (concatenate 'string x y)))

(defun nx-flatten-1 (lst)
	(loop for x in lst
				append (if (listp x) x (list x))))

(defun nx-prepend-to-all (prefix lst)
	(mapcar (lambda (x)
						(concatenate 'string prefix x))
					lst))

(defun nx-append-to-all (suffix lst)
	(mapcar (lambda (x)
						(concatenate 'string x suffix))
					lst))

(defun nx-double-list-p (x)
  (and (listp x)
       (some #'listp x)))

(defun nx-flat-list-p (x)
  (and (listp x)
       (every #'atom x)))

(defun %nx-tok-q(ptok ctok)
	(cond
		((integerp ptok)
			(format t "		integer: ~a~%" ptok))
		((ratiop ptok)
			(format t "		ratio: ~a~%" ptok))
		(t
			(format t "  404 rational: ~a ~%" ptok))
	) ptok)

(defun %nx-tok-r(ptok ctok)
	(cond
		((rationalp ptok)
			(format t "		 rational: ~a~%" ptok)
			(setf ctok (%nx-tok-q ptok ctok)))
		((floatp ptok)
			(format t "		 float: ~a~%" ptok))
		(t
			(format t "		 404 real: ~a ~%" ptok))
	) ctok)

(defun %nx-tok-c(ptok ctok)
	(cond
		((complexp ptok)
			(format t "  complex: ~a~%" ptok))
		((realp ptok)
			(format t "  real: ~a~%" ptok)
			(setf ctok (%nx-tok-r ptok ctok)))
		(t
			(format t "  404 complex: ~a ~%" ptok))
	) ctok)

(defun %nx-tok-atom (ptok ctok)
  (setf ctok
        (cond
          ;; NULL atom
          ((null ptok)
           (format t " null: ~a~%" ptok)
           ctok)

          ;; STRING atom — your custom logic
((stringp ptok)
 (format t " string: ~a~%" ptok)
 (cond
   ;; ctok is NIL → start a flat list
   ((null ctok)
    (list ptok))

   ;; ctok is a flat list → append ptok as a new element
   ((nx-flat-list-p ctok)
    (append ctok (list ptok)))

   ;; ctok is a double list → prepend ptok to all inner lists
   ((nx-double-list-p ctok)
    (mapcar (lambda (inner)
              (concatenate 'string ptok inner))
            ctok))

   (t
    (error "Invalid ctok shape: ~S" ctok))))






          ;; NUMBER atom
          ((numberp ptok)
           (format t " number: ~a~%" ptok)
           (%nx-tok-c ptok ctok))

          ;; fallback
          (t
           (format t " 404 atom: ~a~%" ptok)
           ctok)))
  ctok)

#|
(defun %nx-tok-atom(ptok ctok)
	(setf ctok
	(cond
		((null ptok) ;;; here TODO
			(format t " null: ~a~%" ptok))
		((stringp ptok) ;;; here TODO
			(format t " string: ~a~%" ptok))
		((numberp ptok)
			(format t " number: ~a~%" ptok)
			(%nx-tok-c ptok ctok))
		(t
			(format t " 404 atom: ~a ~%" ptok))
	)) ctok)
|#

(defun %nx-tok-con (ptok ctok)
	(setf ctok
				(cond
					;; Case 1: no accumulator yet -> flatten ptok
					((null ctok)
						(nx-flatten-1 ptok))
					;; Case 2: ctok is a string -> prepend to all, then flatten
					((stringp ctok)
					 (format t "~a was ~%" ctok)
						(nx-flatten-1 (nx-append-to-all ctok ptok)))
							;; Case 3: ctok is a list -> crop‑merge, then flatten
							((listp ctok)
								(nx-flatten-1 (nx-crop-merge ctok ptok)))
		(t
			(error "Invalid ctok in %nx-tok-con: ~S" ctok))))
	ctok)

#|(defun nx-tok-jmp(ptok ctok)
(defun %nx-tok-cmp(ptok ctok)
(defun %nx-tok-ret(tok vtok)|#

(defun nx-tok-br (&rest rest)
	(when rest
		(let ((ctok (pop rest)))
			(loop
					;; save previous
					for ptok = ctok

					;; pop next
					do (setf ctok (pop rest))
					do (cond
						((atom ptok)
							(format t "atom: ~a~%" ptok)
							(setf ctok (%nx-tok-atom ptok ctok)))
						((listp ptok)
							(format t "list: ~a~%" ptok)
							(setf ctok (%nx-tok-con ptok ctok)))
						(t
							(format t "404: ~a ~%" ptok)))
				;; continue while there are still items left
				while rest)
	ctok)))

(print (nx-tok-br "a" "b" "c" "d" "e"  '("f" "g") "h"))
;(print (nx-tok-br '("f" "g") "h"))

