;;; nex-config.lisp
;;; Nyxt module loader
(in-package #:nyxt-user)

(define-configuration (web-buffer)
  ((default-modes
    (remove-if
     (lambda (nyxt::m) (string= (symbol-name nyxt::m) "NO-SCRIPT-MODE"))
     %slot-value%))))

(define-mode generic-identity-mode ()
  "A standards-aligned, generic browser identity."
  ((user-agent
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/605.1.15 (KHTML, like Gecko) GenericBrowser/1.0")
   (navigator-platform "Linux x86_64")
   (navigator-vendor "")
   (navigator-product "Gecko")
   (navigator-build-id "20100101")
   (navigator-user-agent-data-enabled nil)))

(define-configuration buffer
  ((default-modes (append '(generic-identity-mode) %slot-default%))))

#|
(define-configuration buffer
  ((keymap
    (let ((map %slot-value%))
      (define-key map "M-x" 'execute-command "C-space" 'nothing)))))
      map))))

(define-configuration input-buffer
  ((override-map
    (let ((map (make-keymap "override-map")))
      (define-key map "C-T" 'delete-buffer)
|#

(define-configuration (web-buffer)
  ((default-modes (pushnew 'nyxt/mode/style:dark-mode %slot-value%))))

(define-configuration browser
  ((remote-execution-p t)
   (theme theme:+dark-theme+)))

(define-configuration (web-buffer)
  ((default-modes (pushnew 'nyxt/mode/blocker:blocker-mode %slot-value%))))

(define-configuration (web-buffer)
  ((default-modes (pushnew 'nyxt/mode/no-script:no-script-mode %slot-value%))))

(define-configuration (web-buffer)
  ((default-modes
    (pushnew 'nyxt/mode/reduce-tracking:reduce-tracking-mode %slot-value%))))

(define-configuration (input-buffer)
  ((default-modes (pushnew 'nyxt/mode/vi:vi-normal-mode %slot-value%))))

(define-configuration (prompt-buffer)
  ((default-modes (pushnew 'nyxt/mode/vi:vi-insert-mode %slot-value%))))

(defmethod customize-instance ((browser browser) &key)
  (setf (slot-value browser 'default-cookie-policy) :never)
  (setf (slot-value browser 'default-new-buffer-url)
    "https://canine-table-brave-startup-page.onrender.com/"))
#|

	    nyxt/mode/bookmarklets:bookmarklets-mode

	    nyxt/mode/history-migration:history-migration-mode



            nyxt/mode/proxy:proxy-mode
            nyxt/mode/remembrance:remembrance-mode nyxt/mode/repeat:repeat-mode


            nyxt/mode/emacs:emacs-mode nyxt/mode/help:help-mode
            nyxt/mode/force-https:force-https-mode
            nyxt/mode/input-edit:input-edit-mode
            nyxt/mode/message:message-mode nyxt/mode/keyscheme:keyscheme-mode
            nyxt/mode/macro-edit:macro-edit-mode
            nyxt/mode/no-procrastinate:no-procrastinate-mode
            nyxt/mode/no-image:no-image-mode
	    nyxt/mode/no-webgl:no-webgl-mode
            nyxt/mode/passthrough:passthrough-mode
            nyxt/mode/repl:repl-mode
	    nyxt/mode/small-web:small-web-mode
            nyxt/mode/style:style-mode
	    nyxt/mode/tts:tts-mode
            nyxt/mode/user-script:user-script-mode nyxt/mode/vi:vi-insert-mode
            nyxt/mode/visual:visual-mode
	    nyxt/mode/watch:watch-mode
            nyxt/mode/bookmark-frequent-visits:bookmark-frequent-visits-mode
            nyxt/mode/certificate-exception:certificate-exception-mode
            nyxt/mode/vi:vi-normal-mode
	    nyxt/mode/autofill:autofill-mode
            nyxt/mode/spell-check:spell-check-mode
            nyxt/mode/search-buffer:search-buffer-mode
	    nyxt/mode/hint:hint-mode
            nyxt/mode/document:document-mode
	    nyxt/mode/password:password-mode
            nyxt/mode/cruise-control:cruise-control-mode
            nyxt/mode/buffer-listing:buffer-listing-mode
	    nyxt/mode/download:download-mode
	    nyxt/mode/expedition:expedition-mode
	    nyxt/mode/preview:preview-mode
            nyxt/web-extensions:extension
            nyxt/mode/reduce-bandwidth:reduce-bandwidth-mode
	    nyxt/mode/list-history:list-history-mode
            nyxt/mode/no-script:no-script-mode
|#


(defmethod customize-instance ((buffer buffer) &key)
  (setf (slot-value buffer 'default-modes)
          '(nyxt/mode/process:process-mode
            nyxt/mode/prompt-buffer:prompt-buffer-mode
            nyxt/mode/record-input-field:record-input-field-mode
            nyxt/mode/reading-line:reading-line-mode
            nyxt/mode/bookmark:bookmark-mode
	    nyxt/mode/annotate:annotate-mode
            nyxt/mode/reduce-tracking:reduce-tracking-mode
	    nyxt/mode/blocker:blocker-mode
            nyxt/mode/history-tree:history-tree-mode
            nyxt/mode/history:history-mode
	    nyxt/mode/file-manager:file-manager-mode
            nyxt/mode/hint-prompt-buffer:hint-prompt-buffer-mode
            nyxt/mode/editor:editor-mode
            nyxt/mode/no-sound:no-sound-mode
            nyxt/mode/editor:plaintext-editor-mode
            nyxt/mode/style:dark-mode base-mode)))


