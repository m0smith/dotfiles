;;
;; thanks to http://stackoverflow.com/a/11529749/850252
;;

(defgroup m0clj-classpath nil
  "Class Loader mode for use with cider."
  :group 'programming)

(defcustom m0clj-classpath-mode-hook nil
  "Run at the very end of `m0clj-classpath-mode'."
  :group 'm0clj-classpath
  :type 'hook)

(defcustom m0clj-classpath-location-mode-hook nil
  "Run at the very end of `m0clj-classpath-location-mode'."
  :group 'm0clj-classpath
  :type 'hook)


(defun print-current-line-id ()
  (interactive)
   (message (concat "current line ID is: " (tabulated-list-get-id))))

(defun m0clj-classpath-which ()
  (interactive)
  (let ((class-name (elt (tabulated-list-get-entry) 1)))
    (message (format "%s from %s" class-name (m0clj-which class-name)))))

(defun m0clj-classpath-find-file ()
  (interactive)
  (let ((type (elt (tabulated-list-get-entry) 0))
	(file-name (elt (tabulated-list-get-entry) 2)))
    (find-file file-name)))

(defun m0clj-classpath-locate ()
  (interactive)
  (let ((resource-key  (tabulated-list-get-id)))
   (m0clj-classpath-location-mode resource-key)))

(defun m0clj-classpath-package-name ()
  (interactive)
  (let ((class-name (elt (tabulated-list-get-entry) 1)))
     (string-match "\\.[^.]*\\'" class-name)
     (substring class-name 0 (match-beginning 0))))

(defun m0clj-classpath-class-name ()
  (interactive)
  (let ((class-name (elt (tabulated-list-get-entry) 1)))
     (string-match "\\.[^.]*\\'" class-name)
     (substring class-name (+ (match-beginning 0) 1))))

(defun m0clj-classpath-kill-ring-save-package ()
  (interactive)
  (let ((s (m0clj-classpath-package-name)))
    (kill-new s)
    (message "Copied %s" s)))

(defun m0clj-classpath-kill-ring-save-class ()
  (interactive)
  (let ((s (m0clj-classpath-class-name)))
    (kill-new s)
    (message "Copied %s" s)))

(defun m0clj-classpath-kill-ring-save-full-class ()
  (interactive)
  (let ((s (elt (tabulated-list-get-entry) 1)))
    (kill-new s)
    (message "Copied %s" s)))

(defun m0clj-classpath-kill-ring-save-import ()
  (interactive)
  (let ((f (format "[%s %s]" (m0clj-classpath-package-name) (m0clj-classpath-class-name))))
    (kill-new f)
    (message "Copied %s" f)))

(defun m0clj-classpath-kill-ring-save-full-import ()
  (interactive)
  (let ((f (format "(:import [%s %s])" (m0clj-classpath-package-name) (m0clj-classpath-class-name))))
    (kill-new f)
    (message "Copied %s" f)))

(defun m0clj-classpath-kill-ring-save-base ()
  (interactive)
  (let ((s (elt (tabulated-list-get-entry) 1)))
    (kill-new s)
    (message "Copied %s" s)))

(defun m0clj-classpath-kill-ring-save-path ()
  (interactive)
  (let ((s (elt (tabulated-list-get-entry) 2)))
    (kill-new s)
    (message "Copied %s" s)))



(defvar m0clj-classpath-mode-map
  (let ((map (make-keymap)))
    (set-keymap-parent map tabulated-list-mode-map)
    (define-key map "=" 'print-current-line-id)
    (define-key map "l" 'm0clj-classpath-locate)
    (define-key map "w" 'm0clj-classpath-which)
    (define-key map "P" 'm0clj-classpath-kill-ring-save-package)
    (define-key map "c" 'm0clj-classpath-kill-ring-save-class)
    (define-key map "C" 'm0clj-classpath-kill-ring-save-full-class)
    (define-key map "i" 'm0clj-classpath-kill-ring-save-import)
    (define-key map "I" 'm0clj-classpath-kill-ring-save-full-import)
    map))

(defvar m0clj-classpath-location-mode-map
  (let ((map (make-keymap)))
    (set-keymap-parent map tabulated-list-mode-map)
    (define-key map "i" 'print-current-line-id)
    (define-key map "f" 'm0clj-classpath-find-file)
    (define-key map "b" 'm0clj-classpath-kill-ring-save-base)
    (define-key map "P" 'm0clj-classpath-kill-ring-save-path)
    map))


(defun m0clj-classpath-locations-of (resource-key)
  (interactive "sResource Name: ")
  (car (read-from-string
	(plist-get 
	 (nrepl-send-string-sync (format "(m0clj-classpath.tools/locations-of \"%s\")" resource-key))
	 :value))))


(define-derived-mode m0clj-classpath tabulated-list-mode 
  "m0clj-classpath" "Major mode m0clj-classpath to interact with classpath 

\\{m0clj-classpath-mode-map}

"
  (setq tabulated-list-format [("Cnt" 3 nil)
                               ("Name" 50 t)
                               ;;("Col3"  10 t)
                               ;;("Col4" 0 nil)
			       ])
  (setq tabulated-list-padding 2)
  (setq tabulated-list-sort-key (cons "Name" nil))
  (tabulated-list-init-header)
  (use-local-map m0clj-classpath-mode-map)
  (run-mode-hooks 'm0clj-classpath-mode-hook))


(define-derived-mode m0clj-classpath-location tabulated-list-mode 
  "m0clj-classpath-location" "Major mode m0clj-classpath-location to interact with classpath

\\{m0clj-classpath-location-mode-map}
"
  (setq tabulated-list-format [("TYP" 3 nil)
                               ("Base" 50 t)
                               ("Path" 50 t)
                               ;;("Col3"  10 t)
                               ;;("Col4" 0 nil)
			       ])
  (setq tabulated-list-padding 2)
  (setq tabulated-list-sort-key (cons "Base" nil))
  (tabulated-list-init-header)
  (use-local-map m0clj-classpath-location-mode-map)
  (run-mode-hooks 'm0clj-classpath-location-mode-hook))


(defun m0clj-classpath-mode (&optional seach-pattern source-func)
  (interactive "sCamelCase: ")
  (pop-to-buffer "*M0CLJ Classpath*" nil)
  (m0clj-classpath)
  (let ((sf (if source-func source-func 'm0clj-class-find)))
	(setq tabulated-list-entries
	      (funcall sf seach-pattern)))
  (tabulated-list-print t))


(defun m0clj-classpath-location-mode (&optional resource-key)
  (interactive "sResource: ")
  (pop-to-buffer (format "*M0CLJ Location:%s*" resource-key) nil)
  (m0clj-classpath-location)
  (setq tabulated-list-entries (m0clj-classpath-locations-of resource-key))
  (tabulated-list-print t))

(defun m0clj-classpath-locate ()
  (interactive)
  (let ((resource-key  (tabulated-list-get-id)))
   (m0clj-classpath-location-mode resource-key)))

(provide 'm0clj-classpath)
