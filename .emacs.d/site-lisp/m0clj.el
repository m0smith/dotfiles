
;;;
;;; search for resources on classpath
;;;

;;(nrepl-send-string-sync "(.getContextClassLoader (Thread/currentThread))")
;;(nrepl-send-string-sync "(.getURLs (.getClassLoader (.getClass clojure-version)))")

(defun m0clj-resource-init ()
  (interactive)
  (nrepl-send-string-sync "(use 'm0clj-classpath.tools)")
  (nrepl-send-string-sync "(m0clj-classpath.tools/m0clj-init)")
  )

(defun m0clj-resource-find (s)
  (interactive "sCamel-case:")
  (message (plist-get 
	    (nrepl-send-string-sync (format "(map first (m0clj-classpath.tools/m0clj-resource-search \"%s\"))" s))
	    :value)))

(defun m0clj-class-find (s)
  (interactive "sCamel-case:")
  (message (plist-get 
	    (nrepl-send-string-sync (format "(map (comp m0clj-classpath.tools/m0clj-path-to-full-class first) (m0clj-classpath.tools/m0clj-class-search \"%s\"))" s))
	    :value)))

(defun m0clj-cider-hook ()
  (m0clj-resource-init)
  (define-key cider-repl-mode-map (kbd "C-S-t") 'm0clj-class-find)
  (define-key cider-repl-mode-map (kbd "C-S-r") 'm0clj-resource-find)
  (eval-after-load 'clojure-mode
    '(progn
       (define-key clojure-mode-map (kbd "C-S-t") 'm0clj-class-find)
       (define-key clojure-mode-map (kbd "C-S-r") 'm0clj-resource-find))))

(add-hook 'nrepl-connected-hook 'm0clj-cider-hook)

;; Recursively generate tags for all *.clj files, 
;; creating tags for def* and namespaces
;; http://webcache.googleusercontent.com/search?q=cache:M1FGmXfA9HEJ:blog.kovanovic.info/emacs-etags-for-clojure/+&cd=2&hl=en&ct=clnk&gl=us&client=firefox-a

(defun m0clj-etags (project-root)
  "Create tags file for clojure project."
  (interactive "DProject Root:")
  (eshell-command
   (format "find %s/src -name \'*.clj\' | xargs etags --regex=@%s -o %s/TAGS" 
	   project-root 
	   (expand-file-name "~/.emacs.d/clojure/clj.etags") 
	   project-root)))

;;
;; See http://stackoverflow.com/a/9141631/850252
;;

(defcustom path-to-ctags "/usr/bin/ctags"
  "File to use when running etags in cygwin"
  :type 'file
  :group 'm0clj)

(defun m0clj-etags-cygwin (dir-name)
 "Create tags file."
 (interactive "Directory: ")
 (shell-command
  (format "%s  --langdef=Clojure --langmap=Clojure:.clj --regex-Clojure='/[ \t\(]*def[a-z]* \([a-z!-]+\)/\1/'  --regex-Clojure='/[ \t\(]*ns \([a-z.]+\)/\1/' -f %s/TAGS -e -R %s" path-to-ctags dir-name (directory-file-name dir-name)))
 )
