(defvar nex-root (file-name-directory load-file-name))


(defun nex-edit-in-vim ()
  (interactive)
  (let ((file (buffer-file-name)))
    (when file
      (save-buffer)
      (call-process "vim" nil nil nil file)
      (revert-buffer t t))))
(global-set-key (kbd "C-c v") 'nex-edit-in-vim)
(setq-default major-mode 'fundamental-mode)
(setq browse-url-browser-function 'w3m-browse-url)

#|
(add-to-list 'load-path (concat nex-root "core"))
(add-to-list 'load-path (concat nex-root "modules"))
(require 'ui)
(require 'keys)
(require 'editor)
(require 'tools)
|#
