;;; nex-vi.lisp
;;; Nyxt vim key bindings
#|
(in-package #:nyxt-user)

(define-configuration (input-buffer)
  ((default-modes (pushnew 'nyxt/mode/vi:vi-normal-mode %slot-value%))))

(define-configuration (prompt-buffer)
  ((default-modes (pushnew 'nyxt/mode/vi:vi-insert-mode %slot-value%))))
|#

