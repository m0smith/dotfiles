(add-to-list 'load-path "~/.emacs.d/site-lisp/")

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



(setq custom-file "~/.emacs-custom.el")
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
     (add-to-list 'package-archives  '("marmalade" . "http://marmalade-repo.org/packages/"))
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
(setq ecb-examples-bufferinfo-buffer-name nil)


;;
;; Malabar Mode
;;    https://github.com/dstu/malabar-mode
(defun malabar-mode-bootstrap ()
  (require 'cedet)
  (require 'semantic)
  (load "semantic/loaddefs.el")
  (semantic-mode 1);;
  (require 'malabar-mode)
  (load "malabar-flycheck")
  
  (malabar-mode)
  (flycheck-mode))
;;(load "malabar-util.el")

(defun m0java-mode-hook ()
  (setq indent-tabs-mode nil))

(add-hook 'java-mode-hook 'm0java-mode-hook)

(add-to-list 'auto-mode-alist '("\\.java\\'" . malabar-mode-bootstrap))
;(add-to-list 'auto-mode-alist '("\\.groovy\\'" . malabar-mode))


;;;
;;; maven-pom-mode
;;;     https://github.com/m0smith/maven-pom-mode
;;;

(add-to-list 'load-path "~/projects/maven-pom-mode")
(load "maven-pom-mode")
     
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

