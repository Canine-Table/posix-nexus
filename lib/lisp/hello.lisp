#!/usr/bin/env -S sbcl --script

#|
	~a		Aesthetic printer Human‑friendly output
	~s		Readable printer Debugging, serialization
	~d		Decimal integer Numbers
	~%		Newline Line breaks
	~@[ … ~]	Print contents only if next argument is non‑NIL

|#

(defun greet (name &optional title zero)
  (format t "Hello, ~a~@[ the master ~s~]!~@[~%The ~d one that was not ~%~]~%" name title zero))

(greet "Canine")
(greet "Canine" "Architect")
(greet "Canine" "Architect" 35)

#|

(let* ((args (rest *posix-argv*))
       (name (first args)))
  (if name
      (format t "Hello, ~a!~%" name)
      (format t "Usage: ./greet.lisp <name>~%")))


(setq a 10)

(let ((args (rest *posix-argv*)))
  (format t "Args: ~a~%" args))

(if (> a 10)
  (format t "Hello from SBCL script mode!~%")
  (format t "Hello from SBCL script mode!~%")
)

|#
