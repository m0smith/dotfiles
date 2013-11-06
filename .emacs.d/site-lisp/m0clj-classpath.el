;;
;; thanks to http://stackoverflow.com/a/11529749/850252
;;

(defgroup m0clj-classpath nil
  "Class Loader mode for use with cider."
  :group 'programming)

(defcustom m0clj-classpath-mode-hook nil
  "Run at the very end of `dired-mode'."
  :group 'm0clj-classpath
  :type 'hook)


(defun print-current-line-id ()
  (interactive)
   (message (concat "current line ID is: " (tabulated-list-get-id))))

(defvar m0clj-classpath-mode-map
  (let ((map (make-keymap)))
    (set-keymap-parent map tabulated-list-mode-map)
    (define-key map "I" 'print-current-line-id)
    map))

(define-derived-mode m0clj-classpath tabulated-list-mode 
  "m0clj-classpath" "Major mode m0clj-classpath to interact with classpath classpath"
  (setq tabulated-list-format [("Class" 18 t)
                               ;;("Col2" 12 nil)
                               ;;("Col3"  10 t)
                               ;;("Col4" 0 nil)
			       ])
  (setq tabulated-list-padding 2)
  (setq tabulated-list-sort-key (cons "Class" nil))
  (tabulated-list-init-header)
  (use-local-map m0clj-classpath-mode-map)
  (run-mode-hooks 'm0clj-classpath-mode-hook))

(defun m0clj-classpath-mode (&optional seach-pattern)
  (interactive "sCamelCase: ")
  (pop-to-buffer "*M0CLJ Resoource*" nil)
  (m0clj-classpath)
  (setq tabulated-list-entries
	(m0clj-class-find* seach-pattern))
  (tabulated-list-print t))

(provide 'm0clj-classpath)
