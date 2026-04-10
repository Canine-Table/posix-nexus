(defpackage :nx-struct.queue
	(:use :cl)
	(:export
		:nx-make-queue
		:nx-make-queue-from-list
		:nx-prequeue-from-list
		:nx-prequeue
		:nx-enqueue
		:nx-dequeue))

(in-package :nx-struct.queue)

(defun nx-make-queue ()
	(cons nil nil))		;; (front . rear)

(defun nx-make-queue-from-list (lst)
	(if (null lst)
			(cons nil nil)
			(let* ((front lst)
						 (rear (last lst)))
				(cons front rear))))

(defun nx-enqueue (item queue)
	(let ((new (cons item nil)))
		(if (null (car queue))					; empty?
				(setf (car queue) new
							(cdr queue) new)
				(setf (cdr (cdr queue)) new
							(cdr queue) new))
		queue))

(defun nx-dequeue (queue)
	(let ((front (car queue)))
		(when front
			(setf (car queue) (cdr front))
			(when (null (car queue))
				(setf (cdr queue) nil))
			(car front))))

(defun nx-prequeue (item queue)
	(let ((new (cons item (car queue))))
		(setf (car queue) new)
		(when (null (cdr queue))			 ; queue was empty
			(setf (cdr queue) new))
		queue))


(defun nx-prequeue-from-list (lst queue)
  (when lst
    (let ((old-front (car queue))
          (old-rear  (cdr queue))
          (lst-rear  (last lst)))
      ;; splice list in front
      (setf (cdr lst-rear) old-front)
      (setf (car queue) lst)

      ;; if queue was empty, rear becomes last of lst
      (when (null old-rear)
        (setf (cdr queue) lst-rear))))
  queue)

