(defpackage :nx-struct.queue
  (:use :cl)
  (:export
		:nx-make-queue
		:nx-make-queue-from-list
    :nx-enqueue
    :nx-dequeue))

(in-package :nx-struct.queue)

(defun nx-make-queue ()
  (cons nil nil))   ;; (front . rear)

(defun nx-make-queue-from-list (lst)
  (if (null lst)
      (cons nil nil)
      (let* ((front lst)
             (rear (last lst)))
        (cons front rear))))

(defun nx-enqueue (item queue)
  (let ((new (cons item nil)))
    (if (null (car queue))          ; empty?
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

