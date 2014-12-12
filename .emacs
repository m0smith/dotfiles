(when (string-equal system-type "windows-nt")
  (setenv "HOME" (getenv "USERPROFILE")))


;; start malabar 2.0

;; Load CEDET.
;; See cedet/common/cedet.info for configuration details.
;; IMPORTANT: Tou must place this *before* any CEDET component (including
;; EIEIO) gets activated by another package (Gnus, auth-source, ...).
(load-file "~/projects/cedet/cedet-devel-load.el")
;; Add further minor-modes to be enabled by semantic-mode.
;; See doc-string of `semantic-default-submodes' for other things
;; you can use here.
;(add-to-list 'semantic-default-submodes 'global-semantic-idle-summary-mode t)
;(add-to-list 'semantic-default-submodes 'global-semantic-idle-completions-mode t)
(add-to-list 'semantic-default-submodes 'global-cedet-m3-minor-mode t)
;; Enable Semantic
(semantic-mode 1)
;; Enable EDE (Project Management) features
(global-ede-mode 1)

;; End malabar 2.0


(add-to-list 'load-path "~/.emacs.d/site-lisp/")


(when (string-equal system-type "windows-nt")
  (add-to-list 'exec-path  "c:/cygwin64/usr/local/bin")
  (add-to-list 'exec-path  "c:/cygwin64/usr/bin")
  (add-to-list 'exec-path  "c:/cygwin64/bin")
  (add-to-list 'exec-path  (expand-file-name "~/bin"))

  (setenv "PATH"
	  (concat
	   (expand-file-name "~/bin") ";"
	   "C:/cygwin64/usr/local/bin" ";"
	   "C:/cygwin64/usr/bin" ";"
	   "C:/cygwin64/bin" ";"
	   (getenv "PATH"))))


(if (eq system-type 'cygwin)
    (load-file "~/.emacs.d/cygwin/init.el"))

;;
;; From http://devblog.avdi.org/2011/10/10/breaking-up-init-el-emacs-reboot-13/
;;

(setq abg-init-dir "~/.emacs.d/init.d")

(if (file-exists-p abg-init-dir)
    (dolist (file (directory-files abg-init-dir t "\.elc$"))
      (load file)))

;;
;;  Customization setup
;;



(setq custom-file (expand-file-name "~/.emacs-custom.el"))
(load custom-file)

;;
;; Load general purpose functions
;;
(load "m0")
(blink-cursor-mode -1)
;;
;; Keys 
;;
(global-set-key [f5] (quote revert-buffer))
(global-set-key [f12] 'm0-set-frame-height)
;;
;; Colors
;;
;;(set-background-color "dark slate grey")
;;(set-cursor-color "green")
;;(set-foreground-color "white")




;;
;; PACKAGE
;;
(message "Require package")
(autoload 'package-initialize "package" t)

(eval-after-load 'package
  '(progn
     ;;(add-to-list 'package-archives  '("marmalade" . "http://marmalade-repo.org/packages/"))
     (add-to-list 'package-archives  '("melpa" . "http://melpa.milkbox.net/packages/") t)

     (message "Starting package")
     ))

(package-initialize)

;;
;; Start the emacs server going
;;
(run-at-time nil nil 
	     (lambda ()
	       (message "Starting server ..")
	       (require 'server)
	       (server-start)
	       (message "Starting server ..  done")
	       (package-initialize)
	       (message "Starting package ..  done")
))



;;;
;;; DIRED Customizations
;;;
;;     See http://stackoverflow.com/questions/1431351/how-do-i-uncompress-unzip-within-emacs
(eval-after-load "dired-aux"
   '(add-to-list 'dired-compress-file-suffixes 
                 '("\\.zip\\'" ".zip" "unzip")))
;;;
;;; Move Text
;;;

(eval-after-load 'package
  '(progn
     (autoload 'move-text-default-bindings "move-text" t)
     (move-text-default-bindings)))

;;
;; Clojure
;;

(defun clojure-mode-bootstrap ()
  (interactive)
  (autoload 'clojure-mode "clojure-mode" t)
  (require 'cider)
  (load-file "~/projects/cljdb/cljdb.el")
  (load "m0clj")
  (when (string-equal system-type "windows-nt")
    (setq cider-lein-command "lein.bat"))
  (clojure-mode))

(add-to-list 'auto-mode-alist '("\\.clj\\'" . clojure-mode-bootstrap))

;;
;; WEB MODE 
;;     http://web-mode.org/
;;
(eval-after-load 'package
  '(progn
     (autoload 'web-mode "web-mode" t)
     (add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
     (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
     (add-to-list 'auto-mode-alist '("\\.jsp\\'" . web-mode))
     (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
     (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
     (add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
     (add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))))


;;
;; ECB
;;
;;     See http://stackoverflow.com/questions/20129637/emacs-24-3-1-cedet-2-0-built-in-and-ecb-20131116-1319-errors-during-the-layou/20797568?noredirect=1#20797568

;; (setq ecb-examples-bufferinfo-buffer-name nil)

;; (defun ecb-on () 
;;   (interactive)
;;   (setq ecb-examples-bufferinfo-buffer-name nil)
;;   (ignore-errors (ecb-activate)))


;;
;; JAVA
;;

(defun m0java-mode-hook ()
  (setq indent-tabs-mode nil)
  (setq tab-width 4))

(add-hook 'java-mode-hook 'm0java-mode-hook)

;(add-to-list 'auto-mode-alist '("\\.groovy\\'" . java-mode))

;;
;; Malabar
;;

(load-file "~/projects/malabar-mode/src/main/lisp/new/malabar-mode.el")

;;
;; Malabar Mode
;;    https://github.com/dstu/malabar-mode
;; (defun malabar-mode-bootstrap ()
;;   (interactive)
;;   (require 'cedet)
;;   (require 'semantic)
;;   (load "semantic/loaddefs.el")
;;   (semantic-mode 1);;
;;   (require 'malabar-mode)
;;   (load "malabar-flycheck")
  
;;   (malabar-mode)
;;   (flycheck-mode))
;;(load "malabar-util.el")


;; Auto-populate an empty java file
;; (add-hook 'malabar-mode-hook 
;; 	  '(lambda ()
;; 	     (when (= 0 (buffer-size))
;; 	       (malabar-codegen-insert-class-template))))

;;(add-to-list 'auto-mode-alist '("\\.java\\'" . malabar-mode-bootstrap))


;;;
;;; Malabar workspace definition
;;;

;; (defun add-to-tags-table-list (dir)
;;   (interactive "DDirectory:")
;;   (if (file-exists-p dir)
;;     (dolist (file (directory-files dir t))
;;       (if (file-exists-p (expand-file-name (concat file "/TAGS")))
;; 	  (add-to-list 'tags-table-list file)))))

;; (add-to-tags-table-list "~/workspace")
;; (add-to-tags-table-list "~/projects")
;;;
;;; projectile
;;;
(require 'projectile)
(projectile-global-mode)

;;;
;;; maven-pom-mode
;;;     https://github.com/m0smith/maven-pom-mode
;;;

(add-to-list 'load-path "~/projects/maven-pom-mode")
(load "maven-pom-mode")


;;;
;;;  SQL
;;;


(load "sql-org-connect")

;;;
;;; jdibug
;;; https://code.google.com/p/jdibug/
;;;  BROKEN
;;(add-to-list 'load-path (expand-file-name "~/.emacs.d/jdibug-0.5"))
;;(require 'jdibug)
     
;;;
;;; JDC
;;;

;(load "jdc")
;(yas-global-mode 1)

;;;
;;; Markdown Mode
;;;     http://jblevins.org/projects/markdown-mode/
;;;

(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(autoload 'gfm-mode "gfm-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . gfm-mode))

;;
;; Random utilites
;;      See http://www.emacswiki.org/emacs/MatthewSmith

(defun dedosify () 
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (search-forward "\15" nil t)
      (replace-match "" nil t))))

(defun list-all-buffers (&optional files-only)
  "Display a list of names of existing buffers.
The list is displayed in a buffer named `*Buffer List*'.
Non-null optional arg FILES-ONLY means mention only file buffers.

For more information, see the function `buffer-menu'."
  (interactive "P")
  (display-buffer (list-buffers-noselect files-only (buffer-list))))


(put 'narrow-to-region 'disabled nil)
