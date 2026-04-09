(defpackage :nx-stream.token
	(:use :cl)
	(:import-from :nx-struct.queue
		:nx-make-queue
		:nx-make-queue-from-list
		:nx-enqueue
		:nx-dequeue)
	(:export :nx-tok-br))

(in-package :nx-stream.token)

(defun nx-crop-zip (a b)
	(loop for x in a
				for y in b
				collect (concatenate 'string x y)))

(defun nx-crop-merge (a b)
	(loop for x in a append
				(loop for y in b
							collect (concatenate 'string x y))))

(defun nx-flatten-once (x)
  (cond
    ((null x) nil)
    ((atom x) (list x))
    ((listp x)
     (loop for el in x
           append (if (listp el) el (list el))))))


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

(defun nx-finalize (x)
  (labels ((nx-flatten-once (lst)
             (loop for el in lst
                   append (cond
                            ((null el) nil)
                            ((atom el) (list el))
                            ((listp el) el)
                            (t nil)))))
    (cond
      ((null x) nil)
      ((atom x) (list x))
      ((listp x)
       (let ((result (nx-flatten-once x)))
         ;; If still nested, flatten again
         (if (some #'listp result)
             (nx-finalize result)
             result))))))


(defun nx-tok-br (&rest rest)
  (let* ((q (nx-make-queue-from-list rest))
         (ptok (nx-dequeue q)))
    (if (null ptok)
        nil
        (progn
          (loop for ctok = (nx-dequeue q)
                while ctok
                do (setf ptok
                         (cond
                           ((and (atom ptok) (atom ctok))
                            (list ptok ctok))
                           ((and (atom ptok) (nx-flat-list-p ctok))
                            (nx-prepend-to-all ptok ctok))
                           ((and (nx-double-list-p ptok) (nx-double-list-p ctok))
                            (mapcar (lambda (sub-a)
                                      (mapcan (lambda (sub-b)
                                                (nx-crop-merge sub-a sub-b))
                                              ctok))
                                    ptok))
                           ((and (nx-double-list-p ptok) (atom ctok))
                            (nx-append-to-all ctok (nx-flatten-once ptok)))
                           ((and (atom ptok) (nx-double-list-p ctok))
                            (mapcar (lambda (lst)
                                      (nx-prepend-to-all ptok lst))
                                    ctok))
                           ((and (nx-flat-list-p ptok) (atom ctok))
                            (nx-append-to-all ctok ptok))
                           ((and (nx-flat-list-p ptok) (nx-flat-list-p ctok))
                            (nx-crop-merge ptok ctok))
                           ((and (nx-flat-list-p ptok) (nx-double-list-p ctok))
                            (mapcar (lambda (lst)
                                      (nx-crop-merge ptok lst))
                                    ctok))
                           ((nx-double-list-p ptok)
                            (nx-tok-br (nx-flatten-1 ptok) ctok))
                           (t ptok))))
          (nx-finalize ptok)))))

