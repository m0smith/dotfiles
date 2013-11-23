(add-to-list 'load-path "~/.emacs.d/site-lisp/")

(if (eq system-type 'cygwin)
    (load-file "~/.emacs.d/cygwin/init.el"))

;;
;; From http://devblog.avdi.org/2011/10/10/breaking-up-init-el-emacs-reboot-13/
;;

(setq abg-init-dir "~/.emacs.d/init.d")
(if (file-exists-p abg-init-dir)
    (dolist (file (directory-files abg-init-dir t "\.el$"))
      (load file)))

;;
;;  Customization setup
;;



(setq custom-file "~/.emacs-custom.el")
(load custom-file)

;;
;; Keys 
;;
(global-set-key [f5] (quote revert-buffer))

;;
;; Colors
;;
;;(set-background-color "dark slate grey")
;;(set-cursor-color "green")
;;(set-foreground-color "white")




;;
;; PACKAGE
;;

(require 'package)

(add-to-list 'package-archives  '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives  '("melpa" . "http://melpa.milkbox.net/packages/") t)

(package-initialize)


;;
;; Start the emacs server going
;;

(require 'server)
(server-start)

;;;
;;; Move Text
;;;

(require 'move-text)
(move-text-default-bindings)

;;
;; Clojure
;;

(require 'clojure-mode)
(require 'cider)
(load-file "~/projects/cljdb/cljdb.el")
(load "m0clj")


;;
;; WEB MODE http://web-mode.org/
;;

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))


;;
;; ECB
;;

;;(setq stack-trace-on-error t)
;;(add-to-list 'load-path "~/projects/ecb/")
;;(require 'ecb)


;;(;;semantic-load-enable-minimum-features) ;; or enable more if you wish


;;
;; Malabar Mode
;;  https://github.com/dstu/malabar-mode
(require 'cedet)
(require 'semantic)
(load "semantic/loaddefs.el")
(semantic-mode 1);;
(require 'malabar-mode)
(load "malabar-util.el")
(setq malabar-groovy-lib-dir (format "%s/lib" malabar-dir))
(add-to-list 'auto-mode-alist '("\\.java\\'" . malabar-mode))



;;
;; Randon utilites
;; See http://www.emacswiki.org/emacs/MatthewSmith

(defun dedosify () 
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (search-forward "\15" nil t)
      (replace-match "" nil t))))

;;(load-file "/home/xubuntu/projects/cljdb/cljdb.el")
;;(require 'cljdb)

;(load-file "/home/xubuntu/projects/nrepl-inspect/nrepl-inspect.el")
;(define-key nrepl-repl-mode-map (kbd "C-c C-i") 'nrepl-inspect)
;(define-key nrepl-interaction-mode-map (kbd "C-c C-i") 'nrepl-inspect)


;;
;; nrepl and ritz
;;
;;(require 'nrepl)






;; (eval-after-load "auto-complete"
;;   '(add-to-list 'ac-modes 'nrepl-mode))

;; (add-hook 'nrepl-mode-hook 'ac-nrepl-setup)
 
;; Some default eldoc facilities
;(add-hook 'nrepl-connected-hook
;(defun pnh-clojure-mode-eldoc-hook ()
;(add-hook 'clojure-mode-hook 'turn-on-eldoc-mode)
;(add-hook 'nrepl-interaction-mode-hook 'nrepl-turn-on-eldoc-mode)
;(nrepl-enable-on-existing-clojure-buffers)))
 
;; Repl mode hook
;(add-hook 'nrepl-mode-hook 'subword-mode)
 
;; Auto completion for NREPL
;(require 'ac-nrepl)
;(eval-after-load "auto-complete"
;'(add-to-list 'ac-modes 'nrepl-mode))
;(add-hook 'nrepl-mode-hook 'ac-nrepl-setup)



;(require 'nrepl-ritz) ;; after (require 'nrepl)
 
;; Ritz middleware
;(define-key nrepl-interaction-mode-map (kbd "C-c C-j") 'nrepl-javadoc)
;(define-key nrepl-mode-map (kbd "C-c C-j") 'nrepl-javadoc)
;(define-key nrepl-interaction-mode-map (kbd "C-c C-a") 'nrepl-apropos)
;(define-key nrepl-mode-map (kbd "C-c C-a") 'nrepl-apropos)
