;;; nex-init.lisp
;;; Nyxt module loader
(in-package #:nyxt-user)

;; ------------------------------------------------------------
;; 1. Resolve module root from environment
;; ------------------------------------------------------------
(defparameter *nexus-nyxt-module-root*
  (let ((base (uiop:getenv "NEXUS_LIB")))
    (when base
      (merge-pathnames
        (uiop:ensure-directory-pathname "lisp/nyxt/")
        (uiop:ensure-directory-pathname base))))
  "Resolved root directory for Nyxt modules under $NEXUS_LIB.")
  (unless (and *nexus-nyxt-module-root*
    (probe-file *nexus-nyxt-module-root*))
  (error "Nexus Nyxt module root does not exist: ~A"
    *nexus-nyxt-module-root*))

;; ------------------------------------------------------------
;; 2. List modules matching Nexus naming grammar
;; ------------------------------------------------------------
(defun string-prefix-p (prefix string)
  "Return true if STRING begins with PREFIX."
  (and (<= (length prefix) (length string))
       (string= prefix string :end2 (length prefix))))

(defun nx-list-modules ()
  "Return all nex-*.lisp modules in *nexus-nyxt-module-root*, excluding nex-init.lisp."
  (when (probe-file *nexus-nyxt-module-root*)
    (remove-if-not
     (lambda (p)
       (let ((name (pathname-name p)))
         (and (string-prefix-p "nex-" name)
              (not (string= name "nex-init")))))
     (uiop/filesystem:directory-files
      *nexus-nyxt-module-root*
      "*.lisp"))))

(defun nx-load (&rest modules)
  "Load specific .lisp modules from *nexus-nyxt-module-root*."
  (dolist (m modules)
    (let ((path (and *nexus-nyxt-module-root*
                     (merge-pathnames m *nexus-nyxt-module-root*))))
      (if (and path (probe-file path))
          (load path)
          (format t "Nx: module not found: ~a~%" m)))))

(defun nx-load-all ()
  "Load all nex-*.lisp modules in *nexus-nyxt-module-root*."
  (dolist (file (nx-list-modules))
    (load file)))

(defun nx-unload ()
  (when (find-package :nexus)
    (do-symbols (sym (find-package :nyxt-user))
      (ignore-errors (unintern sym :nyxt-user)))))

(defmacro nx-when (test &body body)
  `(when ,test
     ,@body))

;;(setf nyxt::*gobject-debug* nil)
(format t ">>> NX CONFIG LOADED <<<~%")

